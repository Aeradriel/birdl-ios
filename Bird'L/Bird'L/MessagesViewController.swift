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
        self.username = "iPhone"
        for i in 1...20 {
            let sender = (i%2 == 0) ? "Syncano" : self.username
            let message = JSQMessage(senderId: sender, displayName: sender, text: "Text")
            self.messages += [message]
        }
        self.collectionView!.reloadData()
        self.senderDisplayName = self.username
        self.senderId = self.username
        self.inputToolbar!.contentView!.leftBarButtonItem = JSQMessagesToolbarButtonFactory.defaultSendButtonItem()
        self.inputToolbar!.contentView!.rightBarButtonItem = JSQMessagesToolbarButtonFactory.defaultAccessoryButtonItem()
        self.inputToolbar!.maximumHeight = 150
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
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let newMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text);
        messages += [newMessage]
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
    }
}
