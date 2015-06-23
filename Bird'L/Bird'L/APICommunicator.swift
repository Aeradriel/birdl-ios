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
                println(data)
                let json = JSON(data: data)
                
                if let userObject = json["user"].asDictionary
                {
                    success!();
                }
                else
                {
                    if errorFunc != nil
                    {
                        var error: String = ""
                        let separator: String = ", "
                        
                        for (key, value) in json
                        {
                            error += (key as! String).capitalizedString + " "
                            for value2 in value.asArray!
                            {
                                error += value2.asString!
                            }
                            error += "\n"
                        }
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
        }
        else
        {
            errorFunc!("Cannot reach server")
        }
        return ret
    }
}

let g_APICommunicator = APICommunicator();