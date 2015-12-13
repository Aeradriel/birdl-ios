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
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - UIViewController delegate
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    //MARK: - UITableView data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        return cell
    }
}
