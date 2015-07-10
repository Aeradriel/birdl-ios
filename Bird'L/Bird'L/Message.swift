//
//  Message.swift
//  Bird'L
//
//  Created by Thibaut Roche on 10/07/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import Foundation

class Message : NSObject
{
    var id: Int!
    var sender_id: Int!
    var receiver_id: Int!
    var content: String!
    
    init(id: Int, sender_id: Int, receiver_id: Int, content: String)
    {
        self.id = id
        self.sender_id = sender_id
        self.receiver_id = receiver_id
        self.content = content
    }
}