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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // MARK: main manager of Core Data for application
    lazy var coreDataManager = { CoreDataManager(modelName: "Notes", completion: nil) }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // MARK: creating custom window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // MARK: creating storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let mainViewControllerIdentifier = "Main"
        let loginViewControllerIdentifier = "Login"
        
        // MARK: setting root view controller depending on user authorization token
        if isUserAuthorized {
            if let mainViewController = storyboard.instantiateViewController(withIdentifier: mainViewControllerIdentifier) as? UISplitViewController {
                window?.rootViewController = mainViewController
            }
        } else {
            if let loginViewController = storyboard.instantiateViewController(withIdentifier: loginViewControllerIdentifier) as? LoginViewController {
                window?.rootViewController = loginViewController
            }
        }
        
        // MARK: CocoaLumberjack configuration
        DDLog.add(DDTTYLogger.sharedInstance)
        DDLog.add(DDASLLogger.sharedInstance)
        
        DDLogInfo("Home directory: \(NSHomeDirectory())")
        
        return true
    }
    
    // PART: - Special things
    
    static let userAuthSettingName = "user_auth_token"
    
    private var isUserAuthorized: Bool {
        if let authToken = UserDefaults.standard.object(forKey: AppDelegate.userAuthSettingName),
            authToken is String {
            return true
        } else {
            return false
        }
    }

}

