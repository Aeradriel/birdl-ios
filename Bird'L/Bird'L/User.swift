//
//  User.swift
//  Bird'L
//
//  Created by Thibaut Roche on 11/07/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation
import WatchConnectivity

class User : NSObject
{
    //Variables
    var id: Int!
    var firstName: String!
    var lastName: String!
    var email: String!
    var gender: Int!
    var birthdate: NSDate!
    var country: Country!
    
    private static var current: User!
    
    //MARK: Init
    init(userInfos: [String : JSON])
    {
        super.init()
        
        if User.userJsonIsValid(userInfos)
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            
            let date = dateFormatter.dateFromString(userInfos["birthdate"]!.asString!)
            let country = userInfos["country"]!.asDictionary!
            
            self.id = userInfos["id"]!.asInt!
            self.firstName = userInfos["first_name"]!.asString!
            self.lastName = userInfos["last_name"]!.asString!
            self.email = userInfos["email"]!.asString!
            self.gender = userInfos["gender"]!.asInt!
            self.birthdate = date!
            self.country = Country(id: country["id"]!.asInt!, andName: country["name"]!.asString!, andLanguage: country["language"]!.asString!)
        }
    }
    
    init(userJson: JSON)
    {
        super.init()
        
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            
            let date = dateFormatter.dateFromString(userJson["birthdate"].asString!)
        
            self.id = userJson["id"].asInt!
            self.firstName = userJson["first_name"].asString!
            self.lastName = userJson["last_name"].asString!
            self.email = userJson["email"].asString!
            self.gender = userJson["gender"].asInt!
            self.birthdate = date!
        
    }
    
    //MARK: Singleton implementation
    class func currentUser() -> User
    {
        return self.current
    }
    
    class func setCurrentUser(userInfos: [String : JSON])
    {
        self.current = User(userInfos: userInfos)
        
        if #available(iOS 9.0, *)
        {
            if (WCSession.defaultSession().reachable)
            {
                do
                {
                    try WCSession.defaultSession().updateApplicationContext(["userId" : self.current.id])
                }
                catch
                {
                    print("User::setCurrentUser => Unable to update application context")
                }
            }
        }
        else
        {
        }
    }
    
    //MARK: Private checks
    private class func userJsonIsValid(userJson: [String : JSON]) -> Bool
    {
        let requiredFields = ["id", "email", "first_name", "last_name", "gender", "birthdate", "country"]
        
        for key in requiredFields
        {
            if userJson[key]!.isNull
            {
                return false
            }
        }
        return true
    }
    
    //MARK: ActiveRecord functions
    class func create(email: String, password : String, first_name : String, last_name : String, gender : Bool, birthdate: String, country_id : Int, success: (() -> Void)?, errorFunc: ((String) -> Void)?)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.registerURL)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let bodyData = "user={\"email\": \"\(email)\",\"first_name\": \"\(first_name)\",\"last_name\": \"\(last_name)\",\"password\": \"\(password)\",\"gender\": \"\(gender ? 1 : 0)\",\"birthdate\": \"\(birthdate)\",\"country_id\": \"\(country_id)\"}"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if (data != nil) {
                let json = JSON(data: data!)
                
                if let _ = json["user"].asDictionary
                {
                    success!();
                }
                else
                {
                    if errorFunc != nil
                    {
                        let error = APICommunicator.errorFromJson(json)
                        
                        errorFunc!(error)
                    }
                }
            }
            else {
                errorFunc!("Can't reach server")
            }
        }
    }
    
    class func update(userDictionary user: NSDictionary, password: String, errorHandler errorFunc: ((String) -> Void)?, successHandler successFunc: (() -> Void)?)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.accountEditionUrl)
        let request = NSMutableURLRequest(URL: url!)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let birthdate = dateFormatter.stringFromDate(user["birthdate"] as! NSDate)
        var bodyData = "user={\"email\": \"" + (user["email"] as! String) + "\",\"first_name\": \""
        
        bodyData += (user["fname"] as! String) + "\",\"last_name\": \"" + (user["lname"] as! String)
        bodyData += "\",\"gender\": \"" + String(user["gender"] as! Int) + "\",\"birthdate\": \""
        bodyData += (birthdate) + "\",\"country_id\": \"" + String(user["country"] as! Int) + "\"}"
        bodyData += "&password=" + password
        
        request.HTTPMethod = "POST"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if (data != nil) {
                let json = JSON(data: data!)
                
                if let _ = json["user"].asDictionary
                {
                    successFunc!();
                }
                else
                {
                    if errorFunc != nil
                    {
                        let error = APICommunicator.errorFromJson(json)
                        
                        errorFunc!(error)
                    }
                }
            }
            else {
                if errorFunc != nil
                {
                    errorFunc!("Can't reach server")
                }
            }
        }
    }
    
    class func getBaseInfo(token: String?, errorHander errorFunc: ((String) -> Void)?, successHandler successFunc: (([String : JSON]) -> Void)?)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.accountEditionUrl)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        request.addValue(token!, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil)
                {
                    let json = JSON(data: data!)
                    
                    if let userObject = json["user"].asDictionary
                    {
                        successFunc!(userObject)
                    }
                    else
                    {
                        if errorFunc != nil
                        {
                            let error = APICommunicator.errorFromJson(json)
                            
                            errorFunc!(error)
                        }
                    }
                }
        }
    }
    
    class func relations(errorHandler errorFunc: ((String) -> Void), successHandler successFunc: ([[String : AnyObject]]) -> Void)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.relationsUrl)
        let request = NSMutableURLRequest(URL: url!)
        var ret: [[String : AnyObject]] = []
        
        request.HTTPMethod = "GET"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil)
                {
                    let json = JSON(data: data!)
                    
                    if let relations = json["relations"].asArray
                    {
                        for rel in relations
                        {
                            let relation = rel.asDictionary!
                            
                            ret.append(["id" : relation["id"]!.asInt!, "name" : "\(relation["first_name"]!.asString!) \(relation["last_name"]!.asString!)"])
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
                    errorFunc("Cannot reach server")
                }
        }
    }

}