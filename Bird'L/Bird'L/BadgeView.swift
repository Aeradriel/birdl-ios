//
//  Badge.swift
//  Bird'L
//
//  Created by Thibaut Roche on 18/06/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import UIKit

class BadgeView : UIView
{
    @IBOutlet weak var topLevelView: UIView!
    @IBOutlet weak var progressCircleView: CircleProgressView!
    @IBOutlet weak var progressionValue: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}