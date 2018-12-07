//
//  LayoutExampleSceneModels.swift
//  Blueprints
//
//  Created by Chris on 06/12/2018.
//  Copyright (c) 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

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
                var iconsImage: UIImage?
            }
            var displayedExampleSections: [DisplayedExampleSection]?
        }
    }
}
