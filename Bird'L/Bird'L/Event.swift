//
//  Event.swift
//  Bird'L
//
//  Created by Thibaut Roche on 28/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation

class Event : NSObject
{
    var id: Int!
    var name: String!
    var type: String!
    var minSlots: Int!
    var maxSlots: Int!
    var date: NSDate!
    var desc: String?
    var ownerId: Int!
    var addressId: Int!
    var language: String?
    
    init(id: Int, name: String, type: String, minSlots: Int, maxSlots: Int, date: String, desc: String?, ownerId: Int, addressId: Int!, language: String?)
    {
        self.id = id
        self.name = name
        self.type = type
        self.minSlots = minSlots
        self.maxSlots = maxSlots
        // self.date = 
        self.desc = desc
        self.ownerId = ownerId
        self.addressId = addressId
        self.language = language
    }
}