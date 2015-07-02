//
//  EventTitleRow.swift
//  Bird'L
//
//  Created by Thibaut Roche on 30/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation

class EventTitleRow : EventRow
{
    var title: String
    
    init(title: String)
    {
        self.title = title
        
        super.init()

        self.cellIdentifier = "EventTitleTableViewCell"
        self.height = 50
    }
}