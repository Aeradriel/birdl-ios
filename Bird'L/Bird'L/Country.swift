//
//  Country.swift
//  Bird'L
//
//  Created by Thibaut Roche on 22/06/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import Foundation

class Country
{
    var name: String!
    var language: String!
    var i18nKey: String!
    var available: Bool = false
    var id: Int = 0
    
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
}