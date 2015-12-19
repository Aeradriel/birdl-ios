//
//  EventUserTableViewCell.swift
//  Bird'L
//
//  Created by Pierre-Olivier Maugis on 17/12/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation

class EventUserTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    //MARK: UITableViewCell methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}