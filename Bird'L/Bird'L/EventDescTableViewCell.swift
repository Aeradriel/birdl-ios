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

    @IBOutlet weak var desc: UILabel!
    //MARK: UITableViewCell methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //override func setSelected(selected: Bool, animated: Bool) {
     //   super.setSelected(selected, animated: animated)
    //}
    
    //MARK: Custom methods
    override func fillCell(row: EventRow)
    {
        if let descRow = row as? EventDescRow
        {
            self.desc.text = descRow.desc
            print(descRow.desc);
            self.desc.textColor = UIColor.whiteColor()
            self.desc.textAlignment = .Center
            self.desc.font = UIFont(name: "Lato-Light", size: 13)
        }
    }
}