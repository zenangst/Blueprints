//
//  LayoutExampleCollectionViewItem.swift
//  Example-OSX
//
//  Created by Chris on 15/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

class LayoutExampleCollectionViewItem: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        view.layer?.borderColor = NSColor.white.cgColor
        view.layer?.borderWidth = 0.0
    }
}
