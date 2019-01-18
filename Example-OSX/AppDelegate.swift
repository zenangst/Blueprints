//
//  AppDelegate.swift
//  Example-OSX
//
//  Created by Chris on 14/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let mainScreen = NSScreen.main ?? NSScreen.screens.first else {
            fatalError("Expected a display.")
        }
        let screenWidth = mainScreen.frame.width
        let screenHeight = mainScreen.frame.height
        let centerX = mainScreen.frame.midX
        let centerY = mainScreen.frame.midY
        let window = NSWindow(contentViewController: RootViewController(withNibName: Constants.xibIdentifiers.layoutExampleScene.rawValue,
                                                                        controllerType: LayoutExampleSceneViewController.self))
        window.setFrame(NSRect.init(x: centerX,
                                    y: centerY,
                                    width: screenWidth/2,
                                    height: screenHeight/2),
                        display: false)

        self.window = window
        self.window?.title = "Blueprints"
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
    }
}

extension AppDelegate {

    static var shared: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }

    var rootViewController: RootViewController {
        return window?.contentViewController as! RootViewController
    }
}
