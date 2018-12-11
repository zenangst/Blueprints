//
//  LayoutSettingsSceneRouter.swift
//  Blueprints
//
//  Created by Chris on 10/12/2018.
//  Copyright (c) 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

@objc protocol LayoutSettingsSceneRoutingLogic {

}

protocol LayoutSettingsSceneDataPassing {

    var dataStore: LayoutSettingsSceneDataStore? { get }
}

extension LayoutSettingsSceneRouter {

    enum StoryboardIdentifier: String {
        case none
    }
}

class LayoutSettingsSceneRouter: RouterProtocol, LayoutSettingsSceneRoutingLogic, LayoutSettingsSceneDataPassing {

    typealias ViewControllerType = LayoutSettingsSceneViewController

    weak var viewController: ViewControllerType?
    var dataStore: LayoutSettingsSceneDataStore?
}

// MARK: - Navigation
extension LayoutSettingsSceneRouter {

}

// MARK: - Passing data
extension LayoutSettingsSceneRouter {

}
