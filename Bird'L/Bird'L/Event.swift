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
    var location: String?
    var belongsToCurrentUser = false;
    var currentUserRegistered : Bool?
    var users: [User] = []
    
    init(id: Int, name: String, type: String, minSlots: Int, maxSlots: Int, date: String, desc: String?, ownerId: Int, addressId: Int!, language: String?, currentUserRegistered: Bool, location: String)
    {
        self.id = id
        self.name = name
        self.type = type
        self.minSlots = minSlots
        self.maxSlots = maxSlots
        let dateFormatter = NSDateFormatter()
        print(date)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let nsdate = dateFormatter.dateFromString(date)
        self.date = nsdate;
        self.desc = desc
        self.ownerId = ownerId
        self.addressId = addressId
        self.language = language
        self.currentUserRegistered = currentUserRegistered
        self.location = location
        print(self.name)
        print(self.location)
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
                            var location : String = "";
                            
                            if (event["address_id"].asInt != nil)
                            {
                                address = event["address_id"].asInt!
                            }
                            let locationJson = event["location"];
                            if (!locationJson.isNull) {
                                location = locationJson.asString!
                            }
                            let newEvent = Event(id: event["id"].asInt!, name: event["name"].asString!, type: event["type"].asString!, minSlots: event["min_slots"].asInt!, maxSlots: event["max_slots"].asInt!, date: event["date"].asString!, desc: event["desc"].asString, ownerId: event["owner_id"].asInt!, addressId: address, language: event["language"].asString, currentUserRegistered: true, location: location)
                            
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
    
    func wasUserPresent() {
        let url = NSURL(string: netConfig.apiURL + netConfig.eventPresenceURL + "?user_id=\(User.currentUser().id)&event_id=\(self.id)")
        print (url);
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil) {
                    let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("totototo:\(datastring)")
                }
        }
    }
    
    func rate(rating: Int, completion: ((NSURLResponse?, NSData?, NSError?) -> Void)) {
        let url = NSURL(string: netConfig.apiURL + netConfig.eventRateURL)
        print (url);
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        let bodyData = "user_id=\(User.currentUser()).id&event_id=\(self.id)&value=\(rating)"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                completion(response, data, error)
        }
    }
}