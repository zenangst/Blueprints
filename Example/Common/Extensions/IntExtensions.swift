//
//  IntExtensions.swift
//  Example
//
//  Created by Chris on 11/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

extension Int {

    init?(_ other: String?) {
        guard let value = other,
            let number = Int(value) else {
                return nil
        }
        self = number
    }
}
