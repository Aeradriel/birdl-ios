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
    override func viewDidLoad()
    {
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
        let loadedBadge = Badge(progression: 89, andName: "Bilingue")
        
        for (i, location) in enumerate(cell.badges)
        {
            let nib = NSBundle.mainBundle().loadNibNamed("BadgeView", owner: self, options: nil)
            let badgeView = nib[0] as! BadgeView
            
            println(cell.moduleTitle)
            badgeView.name.text = loadedBadge.name
            badgeView.progressionValue.text = "\(loadedBadge.progression)%"
            badgeView.progressCircleView.progress = Double(loadedBadge.progression) / 100.0
            badgeView.name.adjustsFontSizeToFitWidth = true
            badgeView.progressionValue.adjustsFontSizeToFitWidth = true
            badgeView.progressionValue.center = badgeView.progressCircleView.center
            badgeView.frame = CGRectMake(0, 0, location.frame.size.width, location.frame.size.height)
            location.addSubview(badgeView)
        }
        return cell
    }
}
