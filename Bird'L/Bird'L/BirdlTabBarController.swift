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
    
        let tbSize = self.tabBar.bounds.size
        
        self.tabBar.translucent = true
        self.tabBar.backgroundImage = self.imageWithColor(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8), size: self.tabBar.bounds.size)
        self.tabBar.tintColor = UIColor.whiteColor()
        self.tabBar.selectionIndicatorImage = self.imageWithColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), size: CGSizeMake(tbSize.width / 5, tbSize.height))
        
        for item in self.tabBar.items!
        {
            item.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: .Normal)
            item.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: .Selected)
            item.image = self.scaleUIImageToSize(item.image!, size: CGSizeMake(24, 24)).imageWithRenderingMode(.AlwaysOriginal)
            item.selectedImage = item.image?.imageWithRenderingMode(.AlwaysOriginal)
        }
    }
    
    //MARK: Helpers
    func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage
    {
        let hasAlpha = true
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
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
