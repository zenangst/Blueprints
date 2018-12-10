//
//  BlueprintLayout.swift
//  Example
//
//  Created by Chris on 06/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

enum BlueprintLayout {
    case vertical
    case horizontal
    case mosaic
    case waterfall
}

extension BlueprintLayout {

    mutating func switchToNextLayout() {
        switch self {
        case .vertical:
            self = .horizontal
        case .horizontal:
            self = .mosaic
        case .mosaic:
            self = .waterfall
        case .waterfall:
            self = .vertical
        }
    }
}

extension BlueprintLayout {

    var title: String {
        switch self {
        case .vertical:
            return "Vertical Blueprint"
        case .horizontal:
            return "Horizontal Blueprint"
        case .mosaic:
            return "Mosaic Blueprint"
        case .waterfall:
            return "Waterfall Blueprint"
        }
    }
}
