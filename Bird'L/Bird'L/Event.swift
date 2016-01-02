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
    var belongsToCurrentUser = false;
    var currentUserRegistered : Bool?
    var users: [User] = []
    
    init(id: Int, name: String, type: String, minSlots: Int, maxSlots: Int, date: String, desc: String?, ownerId: Int, addressId: Int!, language: String?, currentUserRegistered: Bool)
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
        self.currentUserRegistered = currentUserRegistered
    }
    
    func toDictionary() -> [String : AnyObject]
    {
        var dic         = [String : AnyObject]()
        
        dic["id"] = self.id
        dic["type"] = self.type
        dic["minSlots"] = self.minSlots
        dic["maxSlots"] = self.maxSlots
        dic["date"] = self.date
        dic["desc"] = self.desc
        dic["ownerId"] = self.ownerId
        dic["addressId"] = self.addressId
        dic["language"] = self.language
        return dic
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
                            var address = 0
                            
                            if (event["address_id"].asInt != nil)
                            {
                                address = event["address_id"].asInt!
                            }
                            let newEvent = Event(id: event["id"].asInt!, name: event["name"].asString!, type: event["type"].asString!, minSlots: event["min_slots"].asInt!, maxSlots: event["max_slots"].asInt!, date: event["date"].asString!, desc: event["desc"].asString, ownerId: event["owner_id"].asInt!, addressId: event["address_id"].asInt, language: event["language"].asString, currentUserRegistered: true)
                            
                            if let users = event["users"].asArray {
                                for user in users {
                                    newEvent.users.append(User(userJson: user))
                                }
                                print(newEvent.users.count)
                            }
                            
                            if (newEvent.ownerId == User.currentUser().id) {
                                newEvent.belongsToCurrentUser = true;
                            }
                            else {
                                newEvent.belongsToCurrentUser = false;
                            }
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
    
    class func includesUser(eventId: Int, errorHandler errorFunc: ((String) -> Void), successHandler successFunc: () -> Void)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.checkEventUrl + "\(eventId)")
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil) {
                    let json = JSON(data: data!)
                    
                    if let _ = json["event"].asDictionary
                    {
                        successFunc()
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
    
    class func register(eventId: Int, errorHandler errorFunc: ((String) -> Void), successHandler successFunc: () -> Void)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.registerEventUrl + "\(eventId)")
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil) {
                    let json = JSON(data: data!)
                    
                    if let _ = json["event"].asDictionary
                    {
                        successFunc()
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
    
    func isCurrentUserRegistered() -> Bool {
        for user in self.users {
            if (user.id == User.currentUser().id) {
                return true
            }
        }
        return false
    }
}