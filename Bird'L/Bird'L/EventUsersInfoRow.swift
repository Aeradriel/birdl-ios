//
//  EventActionsRow.swift
//  Bird'L
//
//  Created by Pierre-Olivier Maugis on 13/12/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation

class EventUsersInfoRow : EventRow
{
    var nbrRegistered: Int
    var maxRegistered: Int
    var registered : Bool
    
    init(_registered: Bool, _nbrRegistered: Int, _maxRegistered: Int)
    {
        self.registered = _registered
        self.maxRegistered = _maxRegistered
        self.nbrRegistered = _nbrRegistered
        
        
        super.init()
        
        self.cellIdentifier = "EventUsersInfoTableViewCell"
        self.height = 75
    }
}