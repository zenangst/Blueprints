import UIKit

@objc protocol LayoutExampleSceneRoutingLogic {

    func routeToLayoutSettingsScene()
}

protocol LayoutExampleSceneDataPassing {
    
    var dataStore: LayoutExampleSceneDataStore? { get }
}

extension LayoutExampleSceneRouter {

    enum StoryboardIdentifier: String {
        case layoutSettings = "LayoutSettings"
    }
}

class LayoutExampleSceneRouter: RouterProtocol, LayoutExampleSceneRoutingLogic, LayoutExampleSceneDataPassing {

    typealias ViewControllerType = LayoutExampleSceneViewController

    weak var viewController: ViewControllerType?
    var dataStore: LayoutExampleSceneDataStore?
}

extension LayoutExampleSceneRouter {

    func routeToLayoutSettingsScene() {
        guard let destinationViewController = viewController?.navigationController?.viewControllers.first(where: { $0 is LayoutSettingsSceneViewController }) as? LayoutSettingsSceneViewController
            else {
                return show(storyboard: .layoutSettings) { [weak self] (destinationViewController: LayoutSettingsSceneViewController) in
                    guard let sourceDataStore = self?.dataStore,
                        var destinationDataStore = destinationViewController.router?.dataStore else {
                            fatalError("Missing prerequisites")
                    }
                    destinationViewController.layoutConfigurationDelegate = self?.viewController
                    self?.passDataToLayoutSettingsScene(source: sourceDataStore,
                                                        destination: &destinationDataStore)
                }
        }
        guard let sourceViewController = viewController,
            let sourceDataStore = dataStore,
            var destinationDataStore = destinationViewController.router?.dataStore else {
                fatalError("Missing prerequisites")
        }
        passDataToLayoutSettingsScene(source: sourceDataStore,
                                      destination: &destinationDataStore)
        navigateToLayoutSettingsScene(source: sourceViewController,
                                      destination: destinationViewController)
    }
}

// MARK: - Navigation
extension LayoutExampleSceneRouter {

    func navigateToLayoutSettingsScene(source: LayoutExampleSceneViewController, destination: LayoutSettingsSceneViewController) {
        destination.layoutConfigurationDelegate = source
        source.show(destination, sender: nil)
    }
}

// MARK: - Passing data
extension LayoutExampleSceneRouter {

    func passDataToLayoutSettingsScene(source: LayoutExampleSceneDataStore, destination: inout LayoutSettingsSceneDataStore) {
        destination.itemsPerRow = viewController?.itemsPerRow
        destination.itemsPerCollumn = viewController?.itemsPerColumn
        destination.minimumInteritemSpacing = viewController?.minimumInteritemSpacing
        destination.minimumLineSpacing = viewController?.minimumLineSpacing
        destination.sectionInsets = viewController?.sectionInsets
        destination.useDynamicHeight = viewController?.useDynamicHeight
    }
}
