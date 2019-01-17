//
//  LayoutExampleSceneModels.swift
//  Example-OSX
//
//  Created by Chris on 16/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

enum LayoutExampleScene {

    enum GetExampleData {
        struct Request {
            var numberOfSections: Int
            var numberOfRowsInSection: Int
        }
        struct Response {
            var exampleSections: [ExampleSection]?
        }
        struct ViewModel {
            struct DisplayedExampleSection {
                var title: String
                var contents: [DisplayedExampleContent]?
            }
            struct DisplayedExampleContent {
                var title: String
                var message: String
                var iconsImage: NSImage?
            }
            var displayedExampleSections: [DisplayedExampleSection]?
        }
    }
}
