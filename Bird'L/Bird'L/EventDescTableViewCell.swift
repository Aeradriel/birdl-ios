//
//  EventDescTableViewCell.swift
//  Bird'L
//
//  Created by Thibaut Roche on 30/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventDescTableViewCell: EventDetailTableViewCell
{
    @IBOutlet weak var desc: UITextView!
    
    //MARK: UITableViewCell methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Custom methods
    override func fillCell(row: EventRow)
    {
        if let descRow = row as? EventDescRow
        {
            self.desc.text = descRow.desc
        }
    }
}