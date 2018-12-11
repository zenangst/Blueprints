//
//  ExampleSection.swift
//  Example
//
//  Created by Chris on 06/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
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
