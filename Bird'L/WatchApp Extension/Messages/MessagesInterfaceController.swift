//
//  MessagesInterfaceController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 18/10/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

let MessageTypeSent     : String    = "messageSentRow"
let MessageTypeReceived : String    = "messageReceivedRow"

class MessagesInterfaceController: WKInterfaceController
{
    //MARK: -
    //MARK: Variables
    @IBOutlet var table: WKInterfaceTable!
    
    var userId          : Int!
    var rowTypes        : [String]                  = [String]()
    var messages        : [[ String : AnyObject ]]  = [[ String : AnyObject ]]()
    
    //MARK: -
    //MARK: WKIntefaceController delegate
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        if let user = context as? [String : AnyObject]
        {
            if let id = user["id"] as? Int
            {
                self.userId = id
            }
        }
        self.setupTable()
    }

    override func willActivate()
    {
        super.willActivate()
        
        if (WCSession.defaultSession().reachable)
        {
            let dic: [String : AnyObject] = [ "request" : "messageList", "id" : self.userId ]
            
            WCSession.defaultSession().sendMessage(dic, replyHandler: self.didReceiveMessagesList, errorHandler:
                { (err) -> Void in
                    print("\(err)")
            })
        }
        else
        {
            print("WCSession is not reachable")
        }
    }

    override func didDeactivate()
    {
        super.didDeactivate()
    }

    //MARK: -
    //MARK: Messages handling
    func didReceiveMessagesList(messagesList: [String : AnyObject])
    {
        if let messages = messagesList["messages"] as? [[String : AnyObject]]
        {
            if (messages != self.messages)
            {
                self.messages = messages
                self.rowTypes = [String]()
                for message in self.messages
                {
                    self.rowTypes.append(message["senderId"] as? Int == self.userId ? MessageTypeReceived : MessageTypeSent)
                }
                self.setupTable()
            }
        }
    }
    
    //MARK: -
    //MARK: WKInterfaceTable handling
    func setupTable()
    {
        self.table.setRowTypes(self.rowTypes)
        
        for var i = 0; i < table.numberOfRows; i++
        {
            switch rowTypes[i]
            {
            case MessageTypeReceived:
                let row = table.rowControllerAtIndex(i) as! MessageReceivedTableRow
                
                row.textLabel.setText(self.messages[i]["content"] as? String)
            case MessageTypeSent:
                let row = table.rowControllerAtIndex(i) as! MessageSentTableRow
                
                row.textLabel.setText(self.messages[i]["content"] as? String)
            default: ()
            }
        }
    }
}
