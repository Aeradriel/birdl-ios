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
    
    
    // toDo : add callback function + proper error messages
    func authenticateUser(email : String, password : String, success: (() -> Void)?, errorFunc: ((String) -> Void)?) {
        
        let url = NSURL(string: netConfig.apiURL + netConfig.loginURL);
        var jsonError : NSError?;
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        var bodyData = "email=\(email)&password=\(password)"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if (data != nil) {
                let json = JSON(data: data)
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
        var jsonError : NSError?
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        var bodyData = "user={\"email\": \"\(email)\",\"first_name\": \"\(first_name)\",\"last_name\": \"\(last_name)\",\"password\": \"\(password)\",\"gender\": \"\(gender ? 1 : 0)\",\"birthdate\": \"\(birthdate)\",\"country_id\": \"\(country_id)\"}"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if (data != nil) {
                let json = JSON(data: data)
                
                if let userObject = json["user"].asDictionary
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
        var jsonError: NSError?
        let request = NSMutableURLRequest(URL: url!)
        var ret: [Country] = []
        var response: NSURLResponse?
        var data: NSData?
        
        request.HTTPMethod = "GET"
        request.addValue(self.token, forHTTPHeaderField: "Access-Token")
        data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &jsonError)
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
        else
        {
            if errorFunc != nil
            {
                errorFunc!("Cannot reach server")
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
                    let json = JSON(data: data)
                    
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
    
    func updateUser(userDictionary user: NSDictionary, errorHander errorFunc: ((String) -> Void)?, successHandler successFunc: (() -> Void)?)
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
        
        request.HTTPMethod = "POST"
        request.addValue(self.token, forHTTPHeaderField: "Access-Token")
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if (data != nil) {
                let json = JSON(data: data)
                
                if let userObject = json["user"].asDictionary
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
    
    func errorFromJson(jsonError: JSON) -> String
    {
        var error: String = ""
        let separator: String = ", "
        
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