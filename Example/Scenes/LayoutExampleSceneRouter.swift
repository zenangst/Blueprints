//
//  LayoutExampleSceneRouter.swift
//  Blueprints
//
//  Created by Chris on 06/12/2018.
//  Copyright (c) 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

@objc protocol LayoutExampleSceneRoutingLogic {

}

protocol LayoutExampleSceneDataPassing {
    var dataStore: LayoutExampleSceneDataStore? { get }
}

extension LayoutExampleSceneRouter {

    enum StoryboardIdentifier: String {
        case none
    }
}

class LayoutExampleSceneRouter: RouterProtocol, LayoutExampleSceneRoutingLogic, LayoutExampleSceneDataPassing {

    typealias ViewControllerType = LayoutExampleSceneViewController

    weak var viewController: ViewControllerType?
    var dataStore: LayoutExampleSceneDataStore?
}

// MARK: - Navigation
extension LayoutExampleSceneRouter {

}

// MARK: - Passing data
extension LayoutExampleSceneRouter {

}
