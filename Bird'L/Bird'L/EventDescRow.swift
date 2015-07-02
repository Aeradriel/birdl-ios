//
//  EventDescRow.swift
//  Bird'L
//
//  Created by Thibaut Roche on 30/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation

class EventDescRow : EventRow
{
    var desc: String
    
    init(desc: String)
    {
        self.desc = desc
     
        super.init()

        self.cellIdentifier = "EventDescTableViewCell"
        self.height = 150
    }
}