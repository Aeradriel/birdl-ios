//
//  TinyTabBar.swift
//  Bird'L
//
//  Created by Thibaut Roche on 21/01/2016.
//  Copyright © 2016 Birdl. All rights reserved.
//

import UIKit

protocol TinyTabBarDelegate
{
    func didSelectTab(index: Int)
}

class TinyTabBar: UIView
{
    //MARK: Variables
    private
    let             tabWidth:           CGFloat                 = 70
    let             defaultColor:       UIColor                 = UIColor.whiteColor()
    
    internal
    var             tabs:               [String]                = []
    var             tabViews:           [TabView]               = []
    var             selectionColor:     UIColor?
    var             selectedTabIndex:   Int?

    var             delegate:           TinyTabBarDelegate?
    
    //MARK: UIViewController delegate
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        var         i           = 0
        
        self.tabViews = []
        for tab in self.tabs
        {
            let     tabView     = NSBundle.mainBundle().loadNibNamed("TabView", owner: self, options: nil).first as! TabView
            var     tabFrame    = self.frame
            let     tapRecog    = UITapGestureRecognizer(target: self, action: "didTouchTab:")
            
            tabFrame.origin.x = CGFloat(i) * tabWidth
            tabFrame.origin.y = 0.0
            tabFrame.size.width = tabWidth
            tabView.frame = tabFrame
            tabView.titleLabel.text = tab
            tabView.selectionIndicator.hidden = true
            if self.selectionColor != nil {
                tabView.selectionIndicator.backgroundColor = self.selectionColor
            } else {
                tabView.selectionIndicator.backgroundColor = defaultColor
            }
            tabView.addGestureRecognizer(tapRecog);
            self.addSubview(tabView)
            self.tabViews.append(tabView)
            i++;
        }
    }
    
    //MARK: Tabs handling
    func didTouchTab(tapRecog: UITapGestureRecognizer)
    {
        var         i       = 0

        for tab in self.tabViews
        {
            if tab == tapRecog.view!
            {
                self.selectTab(i)
            }
            i++
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
        if self.delegate != nil
        {
            self.delegate?.didSelectTab(index)
        }
    }
}
