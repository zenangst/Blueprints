//
//  NSEdgeInsetsExtensions.swift
//  Example-OSX
//
//  Created by Chris on 16/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

extension NSEdgeInsets: Equatable {

    public static func == (lhs: NSEdgeInsets, rhs: NSEdgeInsets) -> Bool {
        return lhs.bottom == rhs.bottom &&
            lhs.left == rhs.left &&
            lhs.right == rhs.right &&
            lhs.top == rhs.top
    }
}
