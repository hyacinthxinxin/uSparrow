//
//  AppDelegate.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var firstLoad = true
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        customizeAppearance()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        showAuth()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        guard firstLoad else {
            return
        }
        showAuth()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }
    
    fileprivate func customizeAppearance() {
        window?.tintColor = Constants.SparrowTheme.tintColor
        UINavigationBar.appearance().barTintColor = Constants.SparrowTheme.backgroundColor
        UINavigationBar.appearance().tintColor = Constants.SparrowTheme.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Constants.SparrowTheme.textColor]
    }
    
    fileprivate func showAuth() {
        if let sparrowNavigationController = window?.rootViewController as? UINavigationController {
            firstLoad = false
            sparrowNavigationController.performSegue(withIdentifier: Constants.SegueIdentifier.ShowAuth, sender: nil)
        }
    }
}

