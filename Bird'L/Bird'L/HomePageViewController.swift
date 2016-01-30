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
    
    
    @IBOutlet weak var progressName1: UILabel!
    
    @IBOutlet weak var noBadgeLabel: UILabel!
    
    @IBOutlet weak var progressName4: UILabel!
    @IBOutlet weak var progressName3: UILabel!
    @IBOutlet weak var progressName2: UILabel!
    @IBOutlet weak var circleProgressView1: CircleProgressView!
    
    @IBOutlet weak var circleProgressView3: CircleProgressView!
    
    @IBOutlet weak var circleProgressView4: CircleProgressView!
    
    //MARK: -
    //MARK: UIViewController functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        MBProgressHUD.showHUDAddedTo( self.view , animated: true)
        User.getBadges() { badges, error in
            if (badges.count > 0) {
                self.circleProgressView1.progress = 1
                self.progressName1.text = badges[0]["name"] as? String
                self.noBadgeLabel.hidden = true
            }
            else {
                self.circleProgressView1.hidden = true
                    self.noBadgeLabel.hidden = false
                self.noBadgeLabel.text = NSLocalizedString("no_badge", comment: "")
            }
            if (badges.count > 1) {
                self.circleProgressView2.progress = 1
                self.progressName1.text = badges[1]["name"] as? String
            }
            else {
                self.circleProgressView2.hidden = true
            }
            if (badges.count > 2) {
                self.circleProgressView3.progress = 1
                self.progressName1.text = badges[2]["name"] as? String
            }
            else {
                self.circleProgressView3.hidden = true
            }
            if (badges.count > 3) {
                self.circleProgressView4.progress = 1
                self.progressName1.text = badges[3]["name"] as? String
            }
            else {
                self.circleProgressView4.hidden = true
            }
            MBProgressHUD.hideHUDForView( self.view , animated: true)
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
