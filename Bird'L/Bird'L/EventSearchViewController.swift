//
//  EventSearchViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 28/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventSearchViewController: UIViewController, TinyTabBarDelegate
{
    @IBOutlet weak var tinyTabBar: TinyTabBar!
    @IBOutlet weak var contentView: UIView!
    
    var controllers: [UIViewController] = []
    var event: Event?
    var eventRows: [EventRow] = []
    
    //MARK: UIViewController functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let             futureVC    = EventListTableViewController()
        let             pastVC      = EventListTableViewController()
        
        futureVC.future = true
        pastVC.future = false
        futureVC.parent = self
        pastVC.parent = self
        self.controllers.append(futureVC)
        self.controllers.append(pastVC)
        self.tinyTabBar.tabs = ["Future", "All"]
        self.tinyTabBar.delegate = self
        self.tinyTabBar.backgroundColor = self.navigationController?.navigationBar.barTintColor
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if self.tinyTabBar.selectedTabIndex == nil
        {
            self.tinyTabBar.selectTab(0)
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.tabBarController?.navigationItem.title = self.title
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("viewWillDisappear")
        self.navigationItem.hidesBackButton = false;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "eventDetailsSegue")
        {
            let destinationVc: EventViewController = segue.destinationViewController as! EventViewController
            
            destinationVc.event = event
            destinationVc.rows = self.eventRows
        }
    }
    
    //MARK: Show event
    func showEvent(event: Event, rows: [EventRow])
    {
        self.event = event
        self.eventRows = rows
        self.performSegueWithIdentifier("eventDetailsSegue", sender: self)
    }
    
    //MARK: TinyTabBar delegate
    func didSelectTab(index: Int)
    {
        if (index < self.controllers.count)
        {
            let     view    = self.controllers[index].view!
            
            for controller in self.controllers
            {
                controller.view!.removeFromSuperview()
            }
            view.frame = self.contentView.bounds
            self.contentView.addSubview(view)
        }
    }
}
