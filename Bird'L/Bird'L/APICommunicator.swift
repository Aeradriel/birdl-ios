//
//  APICommunicator.swift
//  Bird'L
//
//  Created by pierre-olivier maugis on 01/06/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import Foundation

class APICommunicator
{
    //MARK: Variables
    var token = ""
    
    //MARK: Init
    init()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let token = userDefaults.valueForKey("access-token")
        
        self.token = token as? String != nil ? token as! String : ""
        User.getBaseInfo(self.token, errorHander: nil, successHandler: User.setCurrentUser)
    }
    
    //MARK: Authentication
    func checkToken(successFunc: () -> Void, errorHandler: (() -> Void)?)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.checkTokenUrl)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        request.addValue(self.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if response != nil
                {
                    let httpResponse = response as! NSHTTPURLResponse
                
                    if httpResponse.statusCode == 200
                    {
                        successFunc()
                    }
                    else
                    {
                        if errorHandler != nil
                        {
                            errorHandler!()
                        }
                    }
                }
                else
                {
                    if errorHandler != nil
                    {
                        errorHandler!()
                    }
                }
        }
    }
    
    func authenticateUser(email : String, password : String, success: (() -> Void)?, errorFunc: ((String) -> Void)?)
    {
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
                            User.getBaseInfo(self.token, errorHander: nil, successHandler: User.setCurrentUser)
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

    
    //MARK: Error handling
    class func errorFromJson(jsonError: JSON) -> String
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
            else if value.isNull == false
            {
                if (value.isString)
                {
                    error = value.asString!
                }
            }
            error += "\n"
        }
        return error
    }
}

let g_APICommunicator = APICommunicator();