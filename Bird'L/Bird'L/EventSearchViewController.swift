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
    
    //MARK: UIViewController functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let             futureVC    = EventListTableViewController()
        let             pastVC      = EventListTableViewController()
        
        futureVC.future = true
        pastVC.future = false
        self.controllers.append(futureVC)
        self.controllers.append(pastVC)
        self.tinyTabBar.tabs = ["Future", "Past"]
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
