//
//  MessagesInterfaceController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 15/10/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import WatchKit
import Foundation

class ContactsListInterfaceController: WKInterfaceController
{
    //MARK: -
    //MARK: Variables
    @IBOutlet var table: WKInterfaceTable!
    var contacts = [ "Jésus", "Zeus", "Thibaut" ]
    
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
    }

    override func didDeactivate()
    {
        super.didDeactivate()
    }
    
    //MARK: -
    //MARK: WKInterfaceTable handling
    func setupTable()
    {
        self.table.setNumberOfRows(self.contacts.count, withRowType: "ContactListRow")
        
        for (var i = 0; i < self.contacts.count; ++i)
        {
            if let row = self.table.rowControllerAtIndex(i) as? ContactsListRow
            {
                row.contactName.setText(self.contacts[i])
            }
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int)
    {
        self.presentControllerWithName("messagesInterface", context: self.contacts[rowIndex])
    }
}
