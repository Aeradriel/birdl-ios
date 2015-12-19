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
    
    func toDictionary() -> [String : AnyObject]
    {
        var dic         = [String : AnyObject]()
        
        dic["id"] = self.id
        dic["senderId"] = self.sender_id
        dic["senderName"] = self.sender_name
        dic["receiverId"] = self.receiver_id
        dic["receiverName"] = self.receiver_name
        dic["content"] = self.content
        return dic
    }
    
    class func with(relation: Int, successFunc: ([Message]) -> Void, errorFunc: (String) -> Void)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.messagesUrl + "?relation=" + String(relation))
        let request = NSMutableURLRequest(URL: url!)
        var ret: [Message] = []
        
        request.HTTPMethod = "GET"
        request.addValue(g_APICommunicator.token, forHTTPHeaderField: "Access-Token")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil)
                {
                    let json = JSON(data: data!)
                    
                    if let messages = json["messages"].asArray
                    {
                        for m in messages
                        {
                            if m.asDictionary != nil
                            {
                                let message = m.asDictionary!
                                let newMessage = Message(id: message["id"]!.asInt!, sender_id: message["sender_id"]!.asInt!, sender_name: message["sender_name"]!.asString!, receiver_id: message["receiver_id"]!.asInt!, receiver_name: message["receiver_name"]!.asString!, content: message["content"]!.asString!)
                                
                                ret.append(newMessage)
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
                    errorFunc("Cannot reach server")
                }
        }
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