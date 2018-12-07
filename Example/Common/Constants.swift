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
        case layoutsExampleScene = "LayoutExample"
    }

    enum CollectionViewCellIdentifiers: String {
        case layoutExampleCell = "LayoutExampleCollectionViewCell"
    }
}

extension UIColor {

    static let blueprintsBlue = UIColor(red: 0.19,
                                        green: 0.48,
                                        blue: 0.93,
                                        alpha: 1.0)
}
