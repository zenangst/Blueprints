//
//  ExampleContent.swift
//  Example-OSX
//
//  Created by Chris on 16/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

struct ExampleContent {
    var title: String
    var message: String
    var iconImage: NSImage?

    init(title: String,
         message: String,
         iconImage: NSImage?) {
        self.title = title
        self.message = message
        self.iconImage = iconImage
    }
}
