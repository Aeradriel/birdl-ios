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
    func authenticateUser(email : String, password : String, completion: (() -> Void)?) {
        
        let url = NSURL(string: netConfig.apiURL + netConfig.loginURL);
        var jsonError : NSError?;
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        var bodyData = "email=\(email)&password=\(password)"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if (data != nil) {
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
                let json = JSON(data: data)
                if let authenticationResult = json["data"].asString {
                    println(authenticationResult)
                    if (authenticationResult == "Authentication succeed") {
                        if let httpResponse = response as? NSHTTPURLResponse {
                            self.token = httpResponse.allHeaderFields["Access-Token"] as String;
                            println(self.token);
                            self.isAuth = true;
                            completion!();
                        }
                        else {
                            println("Authentication failed")
                        }
                    }
                    else {
                        println("Incorrect email or password");
                    }
                    
                } else {
                    println("Can't connect to the server")
                }
            }
        }
        
    }
    
    
    func createAccount(email: String, password : String, first_name : String, last_name : String, gender : Bool, birthdate: String, country_id : Int) {
        
        let url = NSURL(string: netConfig.apiURL + netConfig.registerURL);
        var jsonError : NSError?;
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        var bodyData = "user={\"email\": \"\(email)\",\"first_name\": \"\(first_name)\",\"last_name\": \"\(last_name)\",\"password\": \"\(password)\",\"gender\": \"\(gender ? 1 : 0)\",\"birthdate\": \"\(birthdate)\",\"country_id\": \"\(country_id)\"}"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if (data != nil) {
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
                let json = JSON(data: data)
                
                if let registrationResult = json["user"].asString {
                    println(registrationResult)
                }
            }
        }
    }
}

let g_APICommunicator = APICommunicator();