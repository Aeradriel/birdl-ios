//
//  EventsInterfaceController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 18/10/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class EventsInterfaceController: WKInterfaceController
{
    //MARK: -
    //MARK: Variables
    @IBOutlet var table: WKInterfaceTable!
    
    var events: [[String : AnyObject]] = [[String : AnyObject]]()
    var rowTypes: [String] = [String]()
    
    
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
        
        self.setupTable()
        if (WCSession.defaultSession().reachable)
        {
            let dic = [ "request" : "eventList" ]
            WCSession.defaultSession().sendMessage(dic, replyHandler: self.didReceiveEventsList, errorHandler:
                { (err) -> Void in
                    print("\(err)")
            })
        }
        else
        {
            print("WCSession is not reachable")
        }
    }

    func didReceiveEventsList(eventsList: [String : AnyObject])
    {
        if let events = eventsList["events"] as? [[String : AnyObject]]
        {
            if (events != self.events)
            {
                var i = 0

                self.events = events
                self.rowTypes = [String]()
                for _ in self.events
                {
                    self.rowTypes.append("dayTableRow");
                    self.rowTypes.append("eventTableRow");
                    i++;
                }
                self.performSelectorOnMainThread("setupTable", withObject: nil, waitUntilDone: false)
            }
        }
    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
    }
    
    //MARK: -
    //MARK: WKInterfaceTable handling
    func setupTable()
    {
        self.table.setRowTypes([String]())
        self.table.setRowTypes(self.rowTypes)
        for var i = 0; i < table.numberOfRows; i++
        {
            let event = self.events[i / 2]
            let dateFormatter = NSDateFormatter()
            let dateFormatterDay = NSDateFormatter()
            var dateBegin = ""
            var dateBeginDay = ""
            var dateEnd = ""

            dateFormatter.dateFormat = "hh:mm"
            dateFormatterDay.dateFormat = "EEE d MMM."
            if event["date"] != nil
            {
                dateBegin = dateFormatter.stringFromDate(event["date"] as! NSDate)
                dateBeginDay = dateFormatterDay.stringFromDate(event["date"] as! NSDate)
            }
            if (event["end"] != nil)
            {
                dateEnd = dateFormatter.stringFromDate(event["end"] as! NSDate)
            }
            switch rowTypes[i]
            {
            case "dayTableRow":
                let row = table.rowControllerAtIndex(i) as! EventDayTableRow
                
                row.dayLabel.setText(dateBeginDay)
            case "eventTableRow":
                let row = table.rowControllerAtIndex(i) as! EventTableRow
                
                row.eventTitleLabel.setText("\(event["name"]!)")
                row.eventDetailsLabel.setText("\(event["location"] == nil ? "" : "\(event["location"])\n")\(dateBegin)-\(dateEnd)")
            default: ()
            }
        }
    }
}
