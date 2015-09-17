//
//  BirdlTabBarController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 17/09/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class BirdlTabBarController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        UITabBar.appearance().translucent = true
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
    }
}
