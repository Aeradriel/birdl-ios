//
//  EventDetailTableViewCell.swift
//  Bird'L
//
//  Created by Thibaut Roche on 30/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventDetailTableViewCell: UITableViewCell
{
    var event : Event!
    
    //MARK: UITableViewCell methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: Custom methods
    func fillCell(row: EventRow)
    {
    }
}
