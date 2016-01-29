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
    var end: NSDate!
    var desc: String?
    var ownerId: Int!
    var addressId: Int!
    var language: String?
    var location: String?
    var belongsToCurrentUser = false;
    var currentUserRegistered : Bool?
    var users: [User] = []
    var owner: User?
    
    init(id: Int, name: String, type: String, minSlots: Int, maxSlots: Int, date: String?, end: String?, desc: String?, ownerId: Int, addressId: Int!, language: String?, currentUserRegistered: Bool, location: String)
    {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        self.id = id
        self.name = name
        self.type = type
        self.minSlots = minSlots
        self.maxSlots = maxSlots
        if date != nil
        {
            self.date = dateFormatter.dateFromString(date!)
        }
        if end != nil
        {
            self.end = dateFormatter.dateFromString(end!)
        }
        self.desc = desc
        self.ownerId = ownerId
        self.addressId = addressId
        self.language = language
        self.currentUserRegistered = currentUserRegistered
        self.location = location
    }
    
    func reinit(id: Int, name: String, type: String, minSlots: Int, maxSlots: Int, date: String?, end: String?, desc: String?, ownerId: Int, addressId: Int!, language: String?, currentUserRegistered: Bool, location: String)
    {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        self.id = id
        self.name = name
        self.type = type
        self.minSlots = minSlots
        self.maxSlots = maxSlots
        if date != nil
        {
            self.date = dateFormatter.dateFromString(date!)
        }
        if end != nil
        {
            self.end = dateFormatter.dateFromString(end!)
        }
        self.desc = desc
        self.ownerId = ownerId
        self.addressId = addressId
        self.language = language
        self.currentUserRegistered = currentUserRegistered
        self.location = location
    }
    
    func toDictionary() -> [String : AnyObject]
    {
        var dic         = [String : AnyObject]()
        
        dic["id"] = self.id
        dic["name"] = self.name
        dic["type"] = self.type
        dic["minSlots"] = self.minSlots
        dic["maxSlots"] = self.maxSlots
        dic["date"] = self.date
        dic["end"] = self.end
        dic["desc"] = self.desc
        dic["ownerId"] = self.ownerId
        dic["addressId"] = self.addressId
        dic["language"] = self.language
        return dic
    }
    
    //MARK: ActiveRecord methods
    class func all(future: Bool = false, userEvents: Bool = false, errorHandler errorFunc: ((String) -> Void), successHandler successFunc: ([Event]) -> Void)
    {
        let url = NSURL(string: netConfig.apiURL + (future ? netConfig.futureEventsUrl : netConfig.eventsUrl) + (userEvents ? "?mine=1" : ""))
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil) {
                    let json = JSON(data: data!)
                    var ret: [Event] = []
                    print(data)
                    if let events = json["events"].asArray
                    {
                        for event in events
                        {
                            var address = 0
                            var location : String = "";
                            
                            if (event["address_id"].asInt != nil)
                            {
                                address = event["address_id"].asInt!
                            }
                            let locationJson = event["location"];
                            if (!locationJson.isNull) {
                                location = locationJson.asString!
                            }
                            let newEvent = Event(id: event["id"].asInt!, name: event["name"].asString!, type: event["type"].asString!, minSlots: event["min_slots"].asInt!, maxSlots: event["max_slots"].asInt!, date: event["date"].asString!, end: event["end"].asString,  desc: event["desc"].asString, ownerId: event["owner_id"].asInt!, addressId: address, language: event["language"].asString, currentUserRegistered: true, location: location)
                            
                            if let users = event["users"].asArray {
                                var userObject : User?
                                for user in users {
                                    userObject = User(userJson: user)
                                    if (userObject!.id == newEvent.ownerId) {
                                        newEvent.owner = userObject
                                    }
                                    else {
                                        newEvent.users.append(userObject!)
                                    }
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
    
    func wasUserPresent(user: User, completion: ((NSString) -> Void)) {
        let url = NSURL(string: netConfig.apiURL + netConfig.eventPresenceURL + "?user_id=\(user.id)&event_id=\(self.id)")
        print (url);
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil) {
                    let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print(datastring!)
                }
        }
    }
    
    func unregister(completion: ((NSURLResponse?, NSData?, NSError?) -> Void)) {
        let url = NSURL(string: netConfig.apiURL + netConfig.eventUnregister + "\(self.id)")
        print (url);
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                completion(response, data, error)
        }
    }
    
    func reload(completion: ((NSURLResponse?, NSData?, NSError?) -> Void)) {
        let url = NSURL(string: netConfig.apiURL + netConfig.eventUrl + "?event_id=\(self.id)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil) {
                    let json = JSON(data: data!)
                    let events = json["events"].asArray
                    var address = 0
                    var location : String = "";
                    for event in events!
                    {
                        if (event["id"].asInt == self.id) {
                            if (event["address_id"].asInt != nil) {
                                address = event["address_id"].asInt!
                            }
                            let locationJson = event["location"];
                            if (!locationJson.isNull) {
                                location = locationJson.asString!
                            }
                            self.reinit(event["id"].asInt!, name: event["name"].asString!, type: event["type"].asString!, minSlots: event["min_slots"].asInt!, maxSlots: event["max_slots"].asInt!, date: event["date"].asString!, end: event["end"].asString,  desc: event["desc"].asString, ownerId: event["owner_id"].asInt!, addressId: address, language: event["language"].asString, currentUserRegistered: true, location: location)
                            if let users = event["users"].asArray {
                                self.users = []
                                var userObject : User?
                                for user in users {
                                    userObject = User(userJson: user)
                                    if (userObject!.id == self.ownerId) {
                                        self.owner = userObject
                                    }
                                    else {
                                        self.users.append(userObject!)
                                    }
                                }
                                self.currentUserRegistered = self.isCurrentUserRegistered()
                                print("totot")
                                print(self.currentUserRegistered)
                            }
                        
                        
                        }
                    }
                }
                completion(response, data, error)
        }
    
    }
    
    func validatePresence(user : User, was_there: Int, completion: ((NSURLResponse?, NSData?, NSError?) -> Void)) {
        let url = NSURL(string: netConfig.apiURL + netConfig.eventPresenceURL)
        print (url);
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        let bodyData = "user_id=\(user.id).id&event_id=\(self.id)&was_there=\(was_there)"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                completion(response, data, error)
        }
    }
}