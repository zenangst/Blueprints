//
//  Constants.swift
//  Example-OSX
//
//  Created by Chris on 15/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

struct Constants {

    enum xibIdentifiers: String {
        case layoutExampleScene = "LayoutExample"
    }

    enum CollectionViewItemIdentifiers: String {
        case layoutExampleItem = "LayoutExampleCollectionViewItem"
    }

    struct ExampleLayoutDefaults {
        static let itemsPerRow: CGFloat = 1
        static let itemsPerColumn: Int = 2
        static let minimumInteritemSpacing: CGFloat = 10
        static let minimumLineSpacing: CGFloat = 10
        static let sectionInsets: NSEdgeInsets = NSEdgeInsets(top: 10,
                                                              left: 10,
                                                              bottom: 10,
                                                              right: 10)
        static let useDynamicHeight = false
    }
}
