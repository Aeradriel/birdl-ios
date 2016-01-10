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

        let nibName = UINib(nibName: "BadgeModuleCell", bundle:nil)
        
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "BadgeModuleCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.tabBarController?.navigationItem.title = self.title
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("BadgeModuleCell") as! BadgeModuleCell
        let loadedBadge = Badge(progression: 89, andName: "Bilingue")
        
        for location in cell.badges
        {
            let nib = NSBundle.mainBundle().loadNibNamed("BadgeView", owner: self, options: nil)
            let badgeView = nib[0] as! BadgeView
            
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
    
    //MARK: Helpers
    func imageWithColor(color: UIColor, size: CGSize) -> UIImage
    {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
