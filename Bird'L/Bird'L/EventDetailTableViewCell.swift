//
//  EventDetailTableViewCell.swift
//  Bird'L
//
//  Created by Thibaut Roche on 30/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventDetailCollectionViewCell: UICollectionViewCell
{
    //MARK: UITableViewCell methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //func setSelected(selected: Bool, animated: Bool) {
    //    super.setSelected(selected, animated: animated)
    //}

    //MARK: Custom methods
    func fillCell(row: EventRow)
    {
    }
    
    func getRatioHeight() -> CGFloat {
        return CGFloat(0.2);
    }
    func getRatioWidth() -> CGFloat {
        return CGFloat(1);
    }
}
