//
//  CGFloatExtensions.swift
//  Example-OSX
//
//  Created by Chris on 21/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

extension CGFloat {

    init?(_ other: String?) {
        guard let value = other,
            let number = NumberFormatter().number(from: value) else {
                return nil
        }
        self.init(number.floatValue)
    }
}
