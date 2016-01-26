//
//  MessagesInterfaceController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 15/10/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class ContactsListInterfaceController: WKInterfaceController
{
    //MARK: -
    //MARK: Variables
    @IBOutlet var table: WKInterfaceTable!
    
    var contacts: [[ String : AnyObject ]] = [[ String : AnyObject ]]()
    
    //MARK: -
    //MARK: WKIntefaceController delegate
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        self.setupTable()
    }

    override func willActivate()
    {
        super.willActivate()
        
        self.setupTable()
        if (WCSession.defaultSession().reachable)
        {
            let dic = [ "request" : "contactList" ]
            WCSession.defaultSession().sendMessage(dic, replyHandler: self.didReceiveContactsList, errorHandler:
                { (err) -> Void in
                    print("\(err)")
            })
        }
        else
        {
            print("WCSession is not reachable")
        }
    }

    func didReceiveContactsList(contactsList: [String : AnyObject])
    {
        if let contacts = contactsList["relations"] as? [[String : AnyObject]]
        {
            if (contacts != self.contacts)
            {
                self.contacts = contacts
                self.performSelectorOnMainThread("setupTable", withObject: nil, waitUntilDone: false)
            }
        }
    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
    }
    
    //MARK: -
    //MARK: WKInterfaceTable handling
    func setupTable()
    {
        self.table.setNumberOfRows(0, withRowType: "ContactListRow")
        self.table.setNumberOfRows(self.contacts.count, withRowType: "ContactListRow")
        
        for (var i = 0; i < self.contacts.count; ++i)
        {
            if let row = self.table.rowControllerAtIndex(i) as? ContactsListRow
            {
                row.contactName.setText(self.contacts[i]["name"] as? String)
            }
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int)
    {
        self.presentControllerWithName("messagesInterface", context: self.contacts[rowIndex])
    }
}
