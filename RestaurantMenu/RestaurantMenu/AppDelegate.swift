//
//  AppDelegate.swift
//  RestaurantMenu
//
//  Created by Siddhesh Mahadeshwar on 25/03/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let coreDataStack = DataStack(modelName: "RestaurantMenu")
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        guard let navigationController = window?.rootViewController as? UINavigationController,
            let viewController = navigationController.topViewController as? ViewController else {fatalError("Application storyboard mis-configuration. Application is mis-configured")}
        
        viewController.coreDataStack = coreDataStack
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
}

