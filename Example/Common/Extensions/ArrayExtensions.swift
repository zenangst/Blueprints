//
//  ArrayExtensions.swift
//  Example
//
//  Created by Chris on 13/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import Foundation

public extension Array {

    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}
