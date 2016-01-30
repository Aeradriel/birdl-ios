//
//  HomePageViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 16/06/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController
{
    
    @IBOutlet weak var circleProgressView2: CircleProgressView!
    
    @IBOutlet weak var circleProgressView1: CircleProgressView!
    
    @IBOutlet weak var circleProgressView3: CircleProgressView!
    
    @IBOutlet weak var circleProgressView4: CircleProgressView!
    
    //MARK: -
    //MARK: UIViewController functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        User.getBadges() { badges, error in
            print("lol")
        }
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
    
}
