//
//  TinyTabBar.swift
//  Bird'L
//
//  Created by Thibaut Roche on 21/01/2016.
//  Copyright © 2016 Birdl. All rights reserved.
//

import UIKit

class TinyTabBar: UIView
{
    private
    let             tabWidth:           CGFloat                 = 70
    let             defaultColor:       UIColor                 = UIColor.whiteColor()
    
    internal
    var             tabs:               [[String : AnyObject]]  = []
    var             tabViews:           [TabView]               = []
    var             controllers:        [UIViewController]      = []
    var             selectionColor:     UIColor?
    var             selectedTabIndex:   Int                     = 0
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        var         i           = 0
        
        for tab in self.tabs
        {
            let     tabView     = NSBundle.mainBundle().loadNibNamed("TabView", owner: self, options: nil).first as! TabView
            var     tabFrame    = self.frame
            
            tabFrame.origin.x = CGFloat(i) * tabWidth
            tabFrame.origin.y = 0.0
            tabFrame.size.width = tabWidth
            tabView.frame = tabFrame
            tabView.titleLabel.text = tab["title"] as? String
            if i == self.selectedTabIndex {
                tabView.selectionIndicator.hidden = false
            } else {
                tabView.selectionIndicator.hidden = true
            }
            if self.selectionColor != nil {
                tabView.selectionIndicator.backgroundColor = self.selectionColor
            } else {
                tabView.selectionIndicator.backgroundColor = defaultColor
            }
            self.addSubview(tabView)
            self.tabViews.append(tabView)
            self.controllers.append(tab["controller"] as! UIViewController)
            i++;
        }
    }
    
    func selectTab(index: Int)
    {
        var         i           = 0
        
        self.selectedTabIndex = index
        while i < self.tabViews.count
        {
            if i == index {
                self.tabViews[i].selectionIndicator.hidden = false
            } else {
                self.tabViews[i].selectionIndicator.hidden = true
            }
            i++
        }
    }
}
