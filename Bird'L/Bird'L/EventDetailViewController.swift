//
//  EventDetailViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 28/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventDetailViewController: UITableViewController
{
    //MARK: Instance variables
    var rows: [EventRow] = []

    //MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()

        var nibName = UINib(nibName: "EventBannerTableViewCell", bundle:nil)
        
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "EventBannerTableViewCell")
        nibName = UINib(nibName: "EventTitleTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "EventTitleTableViewCell")
        nibName = UINib(nibName: "EventDescTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "EventDescTableViewCell")
        nibName = UINib(nibName: "EventAddressTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "EventAddressTableViewCell")
        nibName = UINib(nibName: "EventMapTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "EventMapTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    //MARK: UITableViewController delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.rows.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return CGFloat(self.rows[indexPath.row].height)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.rows[indexPath.row].cellIdentifier, forIndexPath: indexPath) as! EventDetailTableViewCell
        
        cell.fillCell(self.rows[indexPath.row])
        return cell
    }
}
