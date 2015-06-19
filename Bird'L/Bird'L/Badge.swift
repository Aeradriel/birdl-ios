//
//  Badge.swift
//  Bird'L
//
//  Created by Thibaut Roche on 18/06/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import Foundation

class Badge
{
    var progression: Int = 0
    var name: String = ""

    init(progression: Int, andName name: String)
    {
        if progression < 0
        {
            self.progression = 0
        }
        else if progression > 100
        {
            self.progression = 100
        }
        else
        {
            self.progression = progression
        }
        self.name = name
    }
}