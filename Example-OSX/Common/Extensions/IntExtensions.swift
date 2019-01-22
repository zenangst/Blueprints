//
//  IntExtensions.swift
//  Example-OSX
//
//  Created by Chris on 21/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
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
