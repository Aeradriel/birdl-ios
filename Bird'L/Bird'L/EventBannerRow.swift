//
//  EventBannerRow.swift
//  Bird'L
//
//  Created by Thibaut Roche on 30/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation

class EventBannerRow : EventRow
{
    var imagePath: String
    
    init(imagePath: String)
    {
        self.imagePath = imagePath
        
        super.init()

        self.cellIdentifier = "EventBannerTableViewCell"
        self.height = 100
    }
}