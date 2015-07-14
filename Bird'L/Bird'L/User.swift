//
//  User.swift
//  Bird'L
//
//  Created by Thibaut Roche on 11/07/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation

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
    
    //MARK: Singleton implementation
    class func currentUser() -> User
    {
        return self.current
    }
    
    class func setCurrentUser(userInfos: [String : JSON])
    {
        self.current = User(userInfos: userInfos)
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
                            
                            ret.append(["id" : relation["id"]!.asInt!, "name" : relation["name"]!.asString!])
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