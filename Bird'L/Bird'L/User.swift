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
    var id: Int!
    var firstName: String!
    var lastName: String!
    var email: String!
    var gender: Int!
    var birthdate: NSDate!
    var country: Country!
    
    private static var current: User!
    
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
    
    class func currentUser() -> User
    {
        return self.current
    }
    
    class func setCurrentUser(userInfos: [String : JSON])
    {
        self.current = User(userInfos: userInfos)
    }
    
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
}