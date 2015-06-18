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
    let apiURL = "http://localhost:3000/api";
    let loginURL = "/login";
    
    func authenticateUser(email : String, password : String) -> Bool {
        let url = NSURL(string: apiURL + loginURL);
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
        return false;
    }
    
    func createAccount() {
        
    }
}

let g_APICommunicator = APICommunicator();