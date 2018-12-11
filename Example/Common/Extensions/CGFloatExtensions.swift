//
//  CGFloatExtensions.swift
//  Example
//
//  Created by Chris on 11/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

extension CGFloat {

    init?(_ other: String?) {
        guard let value = other,
            let number = NumberFormatter().number(from: value) else {
                return nil
        }
        self.init(number.floatValue)
    }
}
