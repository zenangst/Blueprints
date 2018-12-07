//
//  AppDelegate.swift
//  Example
//
//  Created by Chris on 06/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .blueprintsBlue
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()

        return true
    }
}

private extension AppDelegate {

    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
}
