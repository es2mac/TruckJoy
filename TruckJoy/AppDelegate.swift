//
//  AppDelegate.swift
//  TruckJoy
//
//  Created by Paul on 7/22/16.
//  Copyright © 2016 Mathemusician.net. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UIApplication.sharedApplication().idleTimerDisabled = true
        
        return true
    }

}

