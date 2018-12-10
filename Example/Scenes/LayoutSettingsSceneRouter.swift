//
//  LayoutSettingsSceneRouter.swift
//  Blueprints
//
//  Created by Chris on 10/12/2018.
//  Copyright (c) 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

@objc protocol LayoutSettingsSceneRoutingLogic {

    func routeToLayoutExampleScene()
}

protocol LayoutSettingsSceneDataPassing {

    var dataStore: LayoutSettingsSceneDataStore? { get }
}

extension LayoutSettingsSceneRouter {

    enum StoryboardIdentifier: String {
        case layoutExample = "LayoutExample"
    }
}

class LayoutSettingsSceneRouter: RouterProtocol, LayoutSettingsSceneRoutingLogic, LayoutSettingsSceneDataPassing {

    typealias ViewControllerType = LayoutSettingsSceneViewController

    weak var viewController: ViewControllerType?
    var dataStore: LayoutSettingsSceneDataStore?
}

extension LayoutSettingsSceneRouter {

    func routeToLayoutExampleScene() {
        guard let destinationViewController = viewController?.navigationController?.viewControllers.first(where: { $0 is LayoutExampleSceneViewController }) as? LayoutExampleSceneViewController
            else {
                return show(storyboard: .layoutExample) { [weak self] (destinationViewController: LayoutExampleSceneViewController) in
                    guard let sourceDataStore = self?.dataStore,
                        var destinationDataStore = destinationViewController.router?.dataStore else {
                            fatalError("Missing prerequisites")
                    }
                    self?.passDataToLayoutExampleScene(source: sourceDataStore,
                                                       destination: &destinationDataStore)
                }
        }
        guard let sourceViewController = viewController,
            let sourceDataStore = dataStore,
            var destinationDataStore = destinationViewController.router?.dataStore else {
                fatalError("Missing prerequisites")
        }
        passDataToLayoutExampleScene(source: sourceDataStore,
                                     destination: &destinationDataStore)
        navigateToLayoutExampleScene(source: sourceViewController,
                                     destination: destinationViewController)
    }
}

// MARK: - Navigation
extension LayoutSettingsSceneRouter {

    // TODO: - Remove destination, implementation not required
    func navigateToLayoutExampleScene(source: LayoutSettingsSceneViewController, destination: LayoutExampleSceneViewController) {
        source.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Passing data
extension LayoutSettingsSceneRouter {

    func passDataToLayoutExampleScene(source: LayoutSettingsSceneDataStore, destination: inout LayoutExampleSceneDataStore) {
        // TODO: - implement datastore properties in layoutExampleInteractor
        /*destination.itemsPerRow = viewController?.itemsPerRow
        destination.itemsPerCollumn = viewController?.itemsPerColumn
        destination.minimumInteritemSpacing = viewController?.minimumInteritemSpacing
        destination.minimumLineSpacing = viewController?.minimumLineSpacing
        destination.sectionInsets = viewController?.sectionInsets*/
    }
}
