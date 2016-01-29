//
//  EventActionsTableViewCell.swift
//  Bird'L
//
//  Created by Pierre-Olivier Maugis on 13/12/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventActionsTableViewCell: EventDetailTableViewCell
{
    
    @IBOutlet weak var registerButton: UIButton!
    
    
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
        if (self.event.belongsToCurrentUser == true) {
            self.registerButton.hidden = true;
            
        }
        else if (self.event.isCurrentUserRegistered()) {
             self.registerButton.hidden = true;
        }
        else {
            if (self.event.users.count == 0) {
                registerButton.setTitle("Be the first", forState: .Normal)
            }
            else if (self.event.users.count == 1) {
                registerButton.setTitle("Join him", forState: .Normal)
            }
            else {
                registerButton.setTitle("Join them !", forState: .Normal)
                 self.registerButton.hidden = false;
            }
        }
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo( self.superview , animated: true)
        Event.register(event.id, errorHandler: errorRegister) { () -> Void in
            MBProgressHUD.hideHUDForView( self.superview , animated: true)
            print("success")

        }
    }
    
    func errorRegister(result: String) {
        MBProgressHUD.hideHUDForView( self.superview , animated: true)
        print("error")
        print(result)
    }
}
