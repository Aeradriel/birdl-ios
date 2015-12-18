//
//  EventActionsTableViewCell.swift
//  Bird'L
//
//  Created by Pierre-Olivier Maugis on 13/12/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventUsersInfoTableViewCell: EventDetailTableViewCell
{
    
    @IBOutlet weak var eventInfoLabel: UILabel!
    
    @IBOutlet weak var eventRegistrationInfoLabel: UILabel!
    
    //MARK: UITableViewCell methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Custom methods
    override func fillCell(row: EventRow)
    {
        let eventRow = row as! EventUsersInfoRow;
        if (self.event.belongsToCurrentUser == true) {
            self.eventInfoLabel.text = "\(self.event.users.count) / " + String(eventRow.maxRegistered) + " People registered.";
            self.eventRegistrationInfoLabel.text = "You created this event."
        }
        else if (self.event.isCurrentUserRegistered()) {
            self.eventInfoLabel.text = "\(self.event.users.count) / " + String(eventRow.maxRegistered) + " People registered.";
            self.eventRegistrationInfoLabel.text = "You are registered to this event."
        }
        else {
            self.eventInfoLabel.text = "\(self.event.users.count) / " + String(eventRow.maxRegistered) + " People registered to this event";
            self.eventRegistrationInfoLabel.text = "You are not registered to this event."
        }
    }
    
    func errorRegister(result: String) {
        MBProgressHUD.hideHUDForView( self.superview , animated: true)
        print("error")
        print(result)
    }
}

