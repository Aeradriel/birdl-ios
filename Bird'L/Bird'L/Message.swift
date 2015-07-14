//
//  Message.swift
//  Bird'L
//
//  Created by Thibaut Roche on 10/07/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import Foundation

class Message : NSObject
{
    var id: Int!
    var sender_id: Int!
    var sender_name: String!
    var receiver_id: Int!
    var receiver_name: String!
    var content: String!
    
    init(id: Int, sender_id: Int, sender_name: String, receiver_id: Int, receiver_name: String, content: String)
    {
        self.id = id
        self.sender_id = sender_id
        self.sender_name = sender_name
        self.receiver_id = receiver_id
        self.receiver_name = receiver_name
        self.content = content
    }
    
    func publish(successFunc: (() -> Void)?, errorFunc: ((String) -> Void)?)
    {
        let baseUrl = netConfig.apiURL + netConfig.newMessageUrl
        let args = "sender_id=\(self.sender_id)&receiver_id=\(self.receiver_id)&content=\(self.content)"
        let request = NSMutableURLRequest(URL: NSURL(string: baseUrl + "?" + args.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)!)

        request.HTTPMethod = "POST"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {(response, data, error) in
            if (data != nil) {
                let json = JSON(data: data!)
                
                if let _ = json["message"].asDictionary
                {
                    if successFunc != nil
                    {
                        successFunc!()
                    }
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
}