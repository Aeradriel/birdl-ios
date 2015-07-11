//
//  MessagesViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 07/07/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class MessagesViewController: JSQMessagesViewController
{
    var username = ""
    var messages = [JSQMessage]()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())

    //MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.username = "\(User.currentUser().firstName) \(User.currentUser().lastName)"
        self.senderDisplayName = self.username
        self.senderId = self.username
        self.inputToolbar!.contentView!.leftBarButtonItem = JSQMessagesToolbarButtonFactory.defaultAccessoryButtonItem()
        self.inputToolbar!.contentView!.rightBarButtonItem = JSQMessagesToolbarButtonFactory.defaultSendButtonItem()
        self.inputToolbar!.maximumHeight = 150
    }
    
    override func viewDidAppear(animated: Bool)
    {
        //TODO: Dynamic relation
        g_APICommunicator.getMessages(1, successFunc: self.messagesDidLoad, errorFunc: self.errorHandler)
    }
    
    //MARK: Callback
    func messagesDidLoad(messages: [Message])
    {
        for message in messages
        {
            let sender = message.sender_name
            let newMessage = JSQMessage(senderId: sender, displayName: sender, text: message.content)
            self.messages += [newMessage]
            self.collectionView!.reloadData()
        }
    }
    
    func errorHandler(error: String)
    {
        UIAlertView(title: "Erreur", message: error, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    //MARK: JSQMessagesViewController methods
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = self.messages[indexPath.row]
        if (data.senderId == self.senderId) {
            return self.outgoingBubble
        } else {
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        let words = split(self.messages[indexPath.row].senderDisplayName.characters) { $0 == " " }.map { String($0) }
        var initials = ""
        
        for i in 0...(words.count >= 2 ? 1 : 0)
        {
            let w = words[i]
            
            initials.append(w[w.startIndex])
        }
        let avatar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: UIColor.grayColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(10), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))

        return avatar
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.messages.count;
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
    {
        let newMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text);
        messages += [newMessage]
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!)
    {
    }
}
