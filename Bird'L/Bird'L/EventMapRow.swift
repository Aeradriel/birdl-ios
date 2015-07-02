//
//  EventMapRow.swift
//  Bird'L
//
//  Created by Thibaut Roche on 30/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation

class EventMapRow : EventRow
{
    var nbr: Int
    var street: String
    var zipcode: String
    var city: String
    
    init(nbr: Int, street: String, zipcode: String, city: String)
    {
        self.nbr = nbr
        self.street = street
        self.zipcode = zipcode
        self.city = city
        
        super.init()
        
        self.cellIdentifier = "EventMapTableViewCell"
        self.height = 125
    }
}