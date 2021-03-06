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
        return section == 0 ? NSLocalizedString("event_creator", comment: "") : NSLocalizedString("users_registered", comment: "")
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
                if (present == "true") {
                    cell.backgroundColor = UIColor(red: 212/255, green: 1, blue: 212/255, alpha: 1)
                }
                else if (present == "false") {
                    cell.backgroundColor = UIColor(red: 1, green: 212/255, blue: 212/255, alpha: 1)
                }
            }
        }
        return cell
    }
    
    func reload() {
        self.event.reload() { response, data, error in
            self.viewDidLoad()
            self.viewWillAppear(true)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedUser : User
        let today = NSDate();
        
        
        let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        selectedUser = (indexPath.section == 0 ? self.event.owner! : self.event.users[indexPath.row])
        if (self.event.date.isLessThanDate(today) && self.event.belongsToCurrentUser) {
            let alertController = UIAlertController(title: NSLocalizedString("presence_validation", comment: ""), message: NSLocalizedString("was_this_user_present_to_event", comment: ""), preferredStyle: .Alert)
            
            // Create the actions
            let yesAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.event.validatePresence(selectedUser, was_there: 1) { (response, data, error) in
                    self.reload()
                }
            }
            
            let noAction = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.event.validatePresence(selectedUser, was_there: 0) { (response, data, error) in
                    self.reload()
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
        let relationController = UIAlertController(title: NSLocalizedString("add_relation", comment: ""), message: NSLocalizedString("do_you_want_to_add_relation", comment: ""), preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: UIAlertActionStyle.Default) {
            UIAlertAction in
            selectedUser.addRelation()
            let addedController = UIAlertController(title: NSLocalizedString("relation_added", comment: ""), message: NSLocalizedString("this_relation_was_added", comment: ""), preferredStyle: .Alert)
            addedController.addAction(closeAction)
            self.presentViewController(addedController, animated: true, completion: nil)
        }
        
        let noAction = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        relationController.addAction(yesAction)
        relationController.addAction(noAction)
        self.presentViewController(relationController, animated: true, completion: nil)
        
    }
}
