//
//  ExtensionDelegate.swift
//  WatchApp Extension
//
//  Created by Thibaut Roche on 15/10/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate
{
    func applicationDidFinishLaunching()
    {
        if (WCSession.isSupported())
        {
            let watchSession = WCSession.defaultSession()
            
            watchSession.delegate = self
            watchSession.activateSession();
        }
    }

    func applicationDidBecomeActive()
    {
    }

    func applicationWillResignActive()
    {
    }
}
