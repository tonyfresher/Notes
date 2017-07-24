//
//  AppDelegate.swift
//  Notes
//
//  Created by Anton Fresher on 11.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjack

let ddloglevel = DDLogLevel.debug

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // MARK: main manager of Core Data for application
    lazy var coreDataManager = { CoreDataManager(modelName: "Notes", completion: nil) }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // MARK: CocoaLumberjack configuration
        DDLog.add(DDTTYLogger.sharedInstance)
        DDLog.add(DDASLLogger.sharedInstance)
        
        DDLogInfo("Home directory: \(NSHomeDirectory())")
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        coreDataManager.saveChanges()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataManager.saveChanges()
    }

}

