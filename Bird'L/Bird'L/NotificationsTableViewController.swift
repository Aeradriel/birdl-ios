//
//  NotificationsTableViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 11/12/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class NotificationsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var  tableView:          UITableView!
    
    var                 notifications:      [Notification] = []
    
    //MARK: - UIViewController delegate
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.tabBarController?.navigationItem.title = self.title
        Notification.all({ (notifications) -> Void in
            self.notifications = notifications
            self.tableView.reloadData()
            }) { (error) -> Void in
            print("\(error)")
        }
        Notification.setRead({ () -> Void in
            self.tabBarController!.tabBar.items![4].badgeValue = nil
            }) { (erro) -> Void in
                NSLog("Could not set notifications as read")
        }
    }

    //MARK: - UITableView data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.notifications.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let         cell    = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        let         notif   = self.notifications[indexPath.row]
        
        cell.textLabel!.text = notif.subject
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = notif.desc
        if notif.seen == false
        {
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        }
        return cell
    }
}
