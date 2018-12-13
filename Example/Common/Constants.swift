//
//  Constants.swift
//  Example
//
//  Created by Chris on 06/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

struct Constants {

    static let cellCornerRadius: CGFloat = 4
    static let cellShadowColor = UIColor.darkGray

    enum StoryboardIdentifiers: String {
        case layoutExampleScene = "LayoutExample"
        case layoutSettingsScene = "LayoutSettings"
    }

    enum CollectionViewCellIdentifiers: String {
        case layoutExampleCell = "LayoutExampleCollectionViewCell"
    }

    struct ExampleLayoutDefaults {
        static let itemsPerRow: CGFloat = 1
        static let itemsPerColumn: Int = 2
        static let minimumInteritemSpacing: CGFloat = 10
        static let minimumLineSpacing: CGFloat = 10
        static let sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 10,
                                                       left: 10,
                                                       bottom: 10,
                                                       right: 10)
        static let useDynamicHeight = false
    }
}

extension UIColor {

    static let blueprintsBlue = UIColor(red: 0.19,
                                        green: 0.48,
                                        blue: 0.93,
                                        alpha: 1.0)
}
