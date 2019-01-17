//
//  ExampleSection.swift
//  Example-OSX
//
//  Created by Chris on 16/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

struct ExampleSection {
    var sectionTitle: String
    var contents: [ExampleContent]?

    init(title: String,
         contents: [ExampleContent]?) {
        self.sectionTitle = title
        self.contents = contents
    }
}
