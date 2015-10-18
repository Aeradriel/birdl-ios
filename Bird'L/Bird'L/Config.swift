//
//  netConfig.swift
//  Bird'L
//
//  Created by pierre-olivier maugis on 19/06/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import Foundation

struct netConfig
{
    //static let apiURL = "http://10.224.9.208:3000/api";
    static let apiURL = "http://163.5.84.208:3000/api";
    //static let apiURL = "http://127.0.0.1:3000/api"
    static let loginURL = "/login"
    static let registerURL = "/register"
    
    static let countriesUrl = "/countries/"
    static let accountEditionUrl = "/me/"
    static let eventsUrl = "/events/"
    static let registerEventUrl = "/event/register/"
    static let checkEventUrl = "/event/check/"
    static let checkTokenUrl = "/check_token/"
    static let relationsUrl = "/messages/relations/"
    static let messagesUrl = "/messages/"
    static let newMessageUrl = "/messages/new/"
}
