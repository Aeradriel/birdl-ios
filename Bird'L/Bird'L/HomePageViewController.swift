//
//  HomePageViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 16/06/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: -
    //MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

        var nibName = UINib(nibName: "BadgeModuleCell", bundle:nil)
        
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "BadgeModuleCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    //MARK: -
    //MARK: UITableViewController functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 150.0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("BadgeModuleCell") as! BadgeModuleCell
        let loadedBadge = Badge(progression: 65, andName: "Bilingue")
        
        for badge in cell.badges
        {
            let nib = NSBundle.mainBundle().loadNibNamed("BadgeView", owner: self, options: nil)
            let badgeView = nib[0] as! BadgeView
            
            badgeView.frame = badge.frame
            badgeView.name.adjustsFontSizeToFitWidth = true
            badgeView.progressionValue.adjustsFontSizeToFitWidth = true
            self.view.addSubview(badgeView)
            //badge.name.text = loadedBadge.name
            //badge.progressionValue.text = "\(loadedBadge.progression)%"
            //badge.progressCircleView.progress = Double(loadedBadge.progression) / 100.0
        }
        return cell
    }
}
