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
