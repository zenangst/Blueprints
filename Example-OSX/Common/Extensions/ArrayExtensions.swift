//
//  ArrayExtensions.swift
//  Example-OSX
//
//  Created by Chris on 16/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Foundation

public extension Array {

    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}
