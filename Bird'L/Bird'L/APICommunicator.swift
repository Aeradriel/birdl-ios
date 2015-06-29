//
//  APICommunicator.swift
//  Bird'L
//
//  Created by pierre-olivier maugis on 01/06/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import Foundation

 class APICommunicator {
    
    var isAuth = false;
    var token = "";
    
    init()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let token = userDefaults.valueForKey("access-token")
        
        self.token =  token as? String != nil ? token as! String : ""
    }
    
    // toDo : add callback function + proper error messages
    func authenticateUser(email : String, password : String, success: (() -> Void)?, errorFunc: ((String) -> Void)?) {
        
        let url = NSURL(string: netConfig.apiURL + netConfig.loginURL);
        var _ : NSError?;
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let bodyData = "email=\(email)&password=\(password)"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if (data != nil) {
                let json = JSON(data: data!)
                if let authenticationResult = json["data"].asString {
                    if (authenticationResult == "Authentication succeed") {
                        if let httpResponse = response as? NSHTTPURLResponse {
                            self.token = httpResponse.allHeaderFields["Access-Token"] as! String;
                            self.isAuth = true;
                            success!();
                        }
                        else {
                            errorFunc!("Authentication failed")
                        }
                    }
                    else {
                        errorFunc!("Unknown Error")
                    }
                    
                } else {
                    errorFunc!("Incorrect email or password")
                }
            }
            else {
                errorFunc!("Can't reach server")
            }
        }
        
    }
    
    
    func createAccount(email: String, password : String, first_name : String, last_name : String, gender : Bool, birthdate: String, country_id : Int, success: (() -> Void)?, errorFunc: ((String) -> Void)?) {
        
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
                        let error = self.errorFromJson(json)

                        errorFunc!(error)
                    }
                }
            }
            else {
                errorFunc!("Can't reach server")
            }
        }
    }
    
    func getAllCountries(errorHandler errorFunc: ((String) -> Void)?) -> [Country]
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.countriesUrl)
        let request = NSMutableURLRequest(URL: url!)
        var ret: [Country] = []
        var response: NSURLResponse?
        var data: NSData?
        
        request.HTTPMethod = "GET"
        request.addValue(self.token, forHTTPHeaderField: "Access-Token")
        do
        {
            data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        }
        catch let error as NSError
        {
            data = nil
            
            if errorFunc != nil
            {
                errorFunc!(error.localizedDescription)
            }
        }
        if data != nil
        {
            let json = JSON(data: data!)
            if let countries = json["countries"].asArray
            {
                for country in countries
                {
                    let newCountry = Country(id: country["id"].asInt!, andName: country["name"].asString, andLanguage: country["language"].asString, andI18nKey: country["i18n_key"].asString, andAvailable: country["available"].asBool!)
                    
                    ret.append(newCountry)
                }
            }
            else if errorFunc != nil
            {
                errorFunc!(errorFromJson(json))
            }
        }
        return ret
    }
    
    func getBaseUserInfo(errorHander errorFunc: ((String) -> Void)?, successHandler successFunc: (([String : JSON]) -> Void)?)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.accountEditionUrl)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        request.addValue(self.token, forHTTPHeaderField: "Access-Token")
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
                            let error = self.errorFromJson(json)
                            
                            errorFunc!(error)
                        }
                    }
                }
        }
    }
    
    func updateUser(userDictionary user: NSDictionary, password: String, errorHandler errorFunc: ((String) -> Void)?, successHandler successFunc: (() -> Void)?)
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
        request.addValue(self.token, forHTTPHeaderField: "Access-Token")
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
                        let error = self.errorFromJson(json)
                        
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
    
    func getAllEvents(errorHandler errorFunc: ((String) -> Void), successHandler successFunc: ([Event]) -> Void)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.eventsUrl)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        request.addValue(self.token, forHTTPHeaderField: "Access-Token")
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
                    let error = self.errorFromJson(json)
                    
                    errorFunc(error)
                }
            }
            else
            {
                errorFunc("Can't reach server")
            }
        }

    }
    
    func checkToken(errorHandler: () -> Void)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.checkTokenUrl)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        request.addValue(self.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if error != nil
                {
                    errorHandler()
                }
        }
    }
    
    func errorFromJson(jsonError: JSON) -> String
    {
        var error: String = ""
        
        for (key, value) in jsonError
        {
            error += (key as! String).capitalizedString + " "
            if value.isArray
            {
                for value2 in value.asArray!
                {
                    error += value2.asString!
                }
            }
            else
            {
                error = value.asString!
            }
            error += "\n"
        }
        return error
    }
}

let g_APICommunicator = APICommunicator();