//
//  Notification.swift
//  Bird'L
//
//  Created by Thibaut Roche on 08/01/2016.
//  Copyright © 2016 Birdl. All rights reserved.
//

import UIKit

class Notification: NSObject
{
    //Variables
    var id: Int!
    var desc: String!
    var subject: String!
    var seen: Bool!
    
    //MARK: Init
    init(notifInfos: [String : JSON])
    {
        super.init()
        
        if Notification.notifJsonIsValid(notifInfos)
        {
            self.id = notifInfos["id"]!.asInt!
            self.desc = notifInfos["text"]!.asString!
            self.subject = notifInfos["subject"]!.asString!
            self.seen = notifInfos["seen"]!.asBool!
        }
    }

    //MARK: Get
    class func all(successFunc: ([Notification]) -> Void, errorFunc: (String) -> Void)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.notificationsUrl)
        let request = NSMutableURLRequest(URL: url!)
        var ret: [Notification] = []
        
        request.HTTPMethod = "GET"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil)
                {
                    let json = JSON(data: data!)
                    
                    if let notifications = json["notifications"].asArray
                    {
                        for n in notifications
                        {
                            if n.asDictionary != nil
                            {
                                let notification = n.asDictionary!
                                let newNotif = Notification(notifInfos: notification)

                                ret.append(newNotif)
                            }
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
                    errorFunc(NSLocalizedString("no_server", comment: ""))
                }
        }
    }
    
    class func setRead(successFunc: () -> Void, errorFunc: (String) -> Void)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.notificationsUrl)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "PUT"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil)
                {
                    let ret = String(data: data!, encoding: NSUTF8StringEncoding)
                    
                    if ret == "\"OK\""
                    {
                        successFunc()
                    }
                    else
                    {
                        let error = APICommunicator.errorFromJson(JSON(data: data!))
                        
                        errorFunc(error)
                    }
                }
                else
                {
                    errorFunc(NSLocalizedString("no_server", comment: ""))
                }
        }
    }
    
    //MARK: Private checks
    private class func notifJsonIsValid(notifJson: [String : JSON]) -> Bool
    {
        let requiredFields = ["id", "text", "subject", "seen"]
        
        for key in requiredFields
        {
            if notifJson[key]!.isNull
            {
                return false
            }
        }
        return true
    }
}
