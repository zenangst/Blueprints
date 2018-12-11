//
//  ExampleContent.swift
//  Example
//
//  Created by Chris on 06/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

struct ExampleContent {
    var title: String
    var message: String
    var iconImage: UIImage?

    init(title: String,
         message: String,
         iconImage: UIImage?) {
        self.title = title
        self.message = message
        self.iconImage = iconImage
    }
}
