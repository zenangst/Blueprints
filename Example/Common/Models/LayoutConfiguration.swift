//
//  LayoutConfiguration.swift
//  Example
//
//  Created by Chris on 11/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

struct LayoutConfiguration {

    var itemsPerRow: CGFloat?
    var itemsPerCollumn: Int?
    var minimumInteritemSpacing: CGFloat?
    var minimumLineSpacing: CGFloat?
    var sectionInsets: UIEdgeInsets?

    init(itemsPerRow: CGFloat?,
         itemsPerCollumn: Int?,
         minimumInteritemSpacing: CGFloat?,
         minimumLineSpacing: CGFloat?,
         sectionInsets: UIEdgeInsets?) {
        self.itemsPerRow = itemsPerRow
        self.itemsPerCollumn = itemsPerCollumn
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInsets = sectionInsets
    }
}
