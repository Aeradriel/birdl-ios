//
//  EventAddressTableViewCell.swift
//  Bird'L
//
//  Created by Thibaut Roche on 30/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventAddressTableViewCell: EventDetailTableViewCell
{
    @IBOutlet weak var address: UITextView!
    
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
        if let addressRow = row as? EventAddressRow
        {
            var addressLitteral = "\(addressRow.nbr) \(addressRow.street)\n"
            
            addressLitteral += "\(addressRow.zipcode) \(addressRow.city)"
            self.address.text = addressLitteral
        }
    }
}