//
//  RelationTableViewCell.swift
//  Bird'L
//
//  Created by Thibaut Roche on 18/09/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class RelationTableViewCell: UITableViewCell
{
    //MARK: Variables
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    
    //MARK: UITableViewCell methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
