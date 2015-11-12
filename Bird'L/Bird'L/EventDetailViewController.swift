//
//  EventDetailViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 28/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //MARK: Instance variables
    @IBOutlet weak var tableView: UITableView!

    var event: Event!
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

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: UITableViewController delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.rows.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return CGFloat(self.rows[indexPath.row].height)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.rows[indexPath.row].cellIdentifier, forIndexPath: indexPath) as! EventDetailTableViewCell
        
        cell.fillCell(self.rows[indexPath.row])
        return cell
    }
}
