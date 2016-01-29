//
//  MessagesViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 07/07/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class MessagesViewController: JSQMessagesViewController, UITextFieldDelegate
{
    var relationId: Int!
    var username = ""
    var messages = [JSQMessage]()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 234/255, green: 103/255, blue: 32/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())

    //MARK: UIViewController methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.username = "\(User.currentUser().firstName) \(User.currentUser().lastName)"
        self.senderDisplayName = self.username
        self.senderId = self.username
        self.inputToolbar!.contentView!.leftBarButtonItem = JSQMessagesToolbarButtonFactory.defaultAccessoryButtonItem()
        self.inputToolbar!.contentView!.rightBarButtonItem = JSQMessagesToolbarButtonFactory.defaultSendButtonItem()
        self.inputToolbar!.maximumHeight = 150
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        MBProgressHUD.showHUDAddedTo( self.view , animated: true)
        Message.with(self.relationId, successFunc: self.messagesDidLoad, errorFunc: self.errorHandler)
    }
    
    //MARK: Callback
    func messagesDidLoad(messages: [Message])
    {
        for message in messages
        {
            let sender = message.sender_name
            let newMessage = JSQMessage(senderId: sender, displayName: sender, text: message.content)
            
            self.messages += [newMessage]
        }
        self.collectionView!.reloadData()
        MBProgressHUD.hideHUDForView( self.view , animated: true)
    }
    
    func messageDidNotPublish(error: String)
    {
        UIAlertView(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_sending_message", comment: "") + "\n\n\(error)", delegate: nil, cancelButtonTitle: "OK").show()
    }

    func errorHandler(error: String)
    {
        UIAlertView(title: NSLocalizedString("error", comment: ""), message: error, delegate: nil, cancelButtonTitle: "OK").show()
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
        let words = self.messages[indexPath.row].senderDisplayName.characters.split() { $0 == " " }.map { String($0) }
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
        Message(id: 0, sender_id: User.currentUser().id, sender_name: "", receiver_id: self.relationId, receiver_name: "", content: text).publish(nil, errorFunc: self.messageDidNotPublish)
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!)
    {
    }
    
    //MARK: Keyboard handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
