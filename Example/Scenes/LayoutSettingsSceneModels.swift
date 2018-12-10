//
//  LayoutSettingsSceneModels.swift
//  Blueprints
//
//  Created by Chris on 10/12/2018.
//  Copyright (c) 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

enum LayoutSettingsScene {

    enum GetLayoutConfiguration {
        struct Request {

        }
        struct Response {
            var itemsPerRow: CGFloat?
            var itemsPerCollumn: Int?
            var minimumInteritemSpacing: CGFloat?
            var minimumLineSpacing: CGFloat?
            var sectionInsets: UIEdgeInsets?
        }
        struct ViewModel {
            var itemsPerRow: String?
            var itemsPerCollumn: String?
            var minimumInteritemSpacing: String?
            var minimumLineSpacing: String?
            var topSectionInset: String?
            var leftSectionInset: String?
            var bottomSectionInset: String?
            var rightSectionInset: String?
        }
    }
}
