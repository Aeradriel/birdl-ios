//
//  EventUsersTableViewCell.swift
//  Bird'L
//
//  Created by Pierre-Olivier Maugis on 17/12/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation

class EventUsersViewController: UITableViewController
{
    var event : Event!
    
    //MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        for user in event.users {
            self.event.wasUserPresent(user) { (present) in
                print("User id \(user.id)")
                print(present)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    //MARK: UITableViewController delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return section == 0 ? "Créateur de l'évènement" : "Participants"
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return section == 0 ? 1 : self.event.users.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventUserTableViewCell") as! EventUserTableViewCell
        if (indexPath.section == 0) {
            if ((self.event.owner) != nil) {
                cell.userName.text = "\( self.event.owner!.firstName) \( self.event.owner!.lastName)"
                cell.userEmail.text = self.event.owner!.email
            }
            
        }
        else {
            cell.userName.text = "\( self.event.users[indexPath.row].firstName) \( self.event.users[indexPath.row].lastName)"
            cell.userEmail.text = self.event.users[indexPath.row].email
            self.event.wasUserPresent(self.event.users[indexPath.row]) { (present) in
                print ("was user \(self.event.users[indexPath.row].email) present : NSString")
                if (present == "true") {
                    cell.backgroundColor = UIColor.greenColor()
                }
                else if (present == "false") {
                    cell.backgroundColor = UIColor.redColor()
                }
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedUser : User
        let today = NSDate();
        
        selectedUser = (indexPath.section == 0 ? self.event.owner! : self.event.users[indexPath.row])
        if (self.event.date.isLessThanDate(today) && self.event.belongsToCurrentUser) {
            let alertController = UIAlertController(title: "Presence validation", message: "Was this user present to your event ?", preferredStyle: .Alert)
            
            // Create the actions
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.event.validatePresence(selectedUser, was_there: 1) { (response, data, error) in
                    print(response)
                }
            }
            
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.event.validatePresence(selectedUser, was_there: 0) { (response, data, error) in
                    print(data)
                }
            }
            
            // Add the actions
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            
            // Present the controller
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if (self.event.date.isLessThanDate(today)) {
            
        }
        
    }
}
