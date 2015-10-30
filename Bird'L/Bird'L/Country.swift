//
//  Country.swift
//  Bird'L
//
//  Created by Thibaut Roche on 22/06/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import Foundation

class Country : NSObject
{
    //MARK: Variables
    var name: String!
    var language: String!
    var i18nKey: String!
    var available: Bool = false
    var id: Int = 0
    
    //MARK: Init
    init(id: Int, andName name: String?, andLanguage language: String?, andI18nKey i18nKey: String?, andAvailable available: Bool = false)
    {
        self.id = id
        self.name = name
        self.language = language
        self.i18nKey = i18nKey
        self.available = available
    }
    
    init(id: Int, andName name: String?, andLanguage language: String?)
    {
        self.id = id
        self.name = name
        self.language = language
    }
    
    //MARK: ActiveRecord functions
    class func all(successFunc: ([Country]) -> Void, errorHandler errorFunc: ((String) -> Void)?)
    {
        let url = NSURL(string: netConfig.apiURL + netConfig.countriesUrl)
        let request = NSMutableURLRequest(URL: url!)
        var ret: [Country] = []
        
        request.HTTPMethod = "GET"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) in
                if (data != nil) {
                    let json = JSON(data: data!)
                    
                    if let countries = json["countries"].asArray
                    {
                        for country in countries
                        {
                            let newCountry = Country(id: country["id"].asInt!, andName: country["name"].asString, andLanguage: country["language"].asString, andI18nKey: country["i18n_key"].asString, andAvailable: country["available"].asBool!)
                            
                            ret.append(newCountry)
                        }
                        successFunc(ret)
                    }
                    else if errorFunc != nil
                    {
                        errorFunc!(APICommunicator.errorFromJson(json))
                    }
                }
                else
                {
                    if errorFunc != nil
                    {
                        errorFunc!("Can't reach server")
                    }
                }
        }
    }
}
