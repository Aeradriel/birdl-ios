//
//  Event.swift
//  Bird'L
//
//  Created by Thibaut Roche on 28/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation

class Event : NSObject
{
    var id: Int!
    var name: String!
    var type: String!
    var minSlots: Int!
    var maxSlots: Int!
    var date: NSDate!
    var desc: String?
    var ownerId: Int!
    var addressId: Int!
    var language: String?
    
    init(id: Int, name: String, type: String, minSlots: Int, maxSlots: Int, date: String, desc: String?, ownerId: Int, addressId: Int!, language: String?)
    {
        self.id = id
        self.name = name
        self.type = type
        self.minSlots = minSlots
        self.maxSlots = maxSlots
        // self.date = 
        self.desc = desc
        self.ownerId = ownerId
        self.addressId = addressId
        self.language = language
    }
    
    //MARK: ActiveRecord methods
    class func all(errorHandler errorFunc: ((String) -> Void), successHandler successFunc: ([Event]) -> Void)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.eventsUrl)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil) {
                    let json = JSON(data: data!)
                    var ret: [Event] = []
                    
                    if let events = json["events"].asArray
                    {
                        for event in events
                        {
                            let newEvent = Event(id: event["id"].asInt!, name: event["name"].asString!, type: event["type"].asString!, minSlots: event["min_slots"].asInt!, maxSlots: event["max_slots"].asInt!, date: event["date"].asString!, desc: event["desc"].asString, ownerId: event["owner_id"].asInt!, addressId: event["address_id"].asInt!, language: event["language"].asString)
                            
                            ret.append(newEvent)
                        }
                        successFunc(ret)
                    }
                    else
                    {
                        let error = APICommunicator.errorFromJson(json)
                        
                        errorFunc(error)
                    }
                }
                else
                {
                    errorFunc("Can't reach server")
                }
        }
    }
}