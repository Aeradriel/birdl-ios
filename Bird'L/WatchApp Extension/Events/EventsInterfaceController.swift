//
//  EventsInterfaceController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 18/10/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import WatchKit
import Foundation


class EventsInterfaceController: WKInterfaceController
{
    //MARK: -
    //MARK: Variables
    @IBOutlet var table: WKInterfaceTable!
    
    var rowTypes: [String] = ["dayTableRow", "eventTableRow", "dayTableRow", "eventTableRow"]
    
    //MARK: -
    //MARK: WKInterface delegate
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        self.setupTable()
    }

    override func willActivate()
    {
        super.willActivate()
    }

    override func didDeactivate()
    {
        super.didDeactivate()
    }
    
    //MARK: -
    //MARK: WKInterfaceTable handling
    func setupTable()
    {
        self.table.setRowTypes(self.rowTypes)
        
        for var i = 0; i < table.numberOfRows; i++
        {
            switch rowTypes[i]
            {
            case "dayTableRow":
                let row = table.rowControllerAtIndex(i) as! EventDayTableRow
                
                row.dayLabel.setText("Lun. 19 oct.")
            case "eventTableRow":
                let row = table.rowControllerAtIndex(i) as! EventTableRow
                
                row.eventTitleLabel.setText("Entraînement de Volley-Ball")
                row.eventDetailsLabel.setText("14 rue carnot, Villejuif, France\n20:30-22:30")
            default: ()
            }
        }
    }
}
