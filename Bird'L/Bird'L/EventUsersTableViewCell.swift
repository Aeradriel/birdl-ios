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
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: UITableViewController delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.event.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventUserTableViewCell") as! EventUserTableViewCell
        cell.userName.text = "\( self.event.users[indexPath.row].firstName) \( self.event.users[indexPath.row].lastName)"
        cell.userEmail.text = self.event.users[indexPath.row].email
        return cell
    }
}
