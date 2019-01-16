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
        configureStyle()
    }
}

private extension LayoutExampleCollectionViewItem {

    func configureStyle() {
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
}
