//
//  EventBannerTableViewCell.swift
//  Bird'L
//
//  Created by Thibaut Roche on 30/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventBannerTableViewCell: EventDetailTableViewCell
{
    
    @IBOutlet weak var banner: UIImageView!
    //MARK: UITableViewCell methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //override func setSelected(selected: Bool, animated: Bool) {
    //    super.setSelected(selected, animated: animated)
    //}
    
    //MARK: Custom methods
    override func fillCell(row: EventRow)
    {
        if let bannerRow = row as? EventBannerRow
        {
            self.banner.image = UIImage(named: bannerRow.imagePath)
        }
    }
}
