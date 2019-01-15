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
        let centerX = NSScreen.main?.frame.midX ?? 0
        let centerY = NSScreen.main?.frame.midY ?? 0
        let window = NSWindow(contentViewController: RootViewController(withNibName: Constants.xibIdentifiers.layoutExampleScene.rawValue,
                                                                        controllerType: LayoutExampleSceneViewController.self))
        window.setFrame(NSRect.init(x: centerX,
                                    y: centerY,
                                    width: 500,
                                    height: 500),
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
