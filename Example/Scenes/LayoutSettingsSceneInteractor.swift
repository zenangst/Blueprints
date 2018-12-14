import UIKit

protocol LayoutSettingsSceneBusinessLogic {

    func getLayoutConfiguration(request: LayoutSettingsScene.GetLayoutConfiguration.Request)
}

protocol LayoutSettingsSceneDataStore {

    var itemsPerRow: CGFloat? { get set }
    var itemsPerCollumn: Int? { get set }
    var minimumInteritemSpacing: CGFloat? { get set }
    var minimumLineSpacing: CGFloat? { get set }
    var sectionInsets: UIEdgeInsets? { get set }
    var useDynamicHeight: Bool? { get set }
}

class LayoutSettingsSceneInteractor: LayoutSettingsSceneBusinessLogic, LayoutSettingsSceneDataStore {
    var presenter: LayoutSettingsScenePresentationLogic?
    var itemsPerRow: CGFloat?
    var itemsPerCollumn: Int?
    var minimumInteritemSpacing: CGFloat?
    var minimumLineSpacing: CGFloat?
    var sectionInsets: UIEdgeInsets?
    var useDynamicHeight: Bool?
}

extension LayoutSettingsSceneInteractor {

    func getLayoutConfiguration(request: LayoutSettingsScene.GetLayoutConfiguration.Request) {
        let layoutConfiguration = LayoutConfiguration(
            itemsPerRow: self.itemsPerRow,
            itemsPerCollumn: self.itemsPerCollumn,
            minimumInteritemSpacing: self.minimumInteritemSpacing,
            minimumLineSpacing: self.minimumLineSpacing,
            sectionInsets: self.sectionInsets,
            useDynamicHeight: self.useDynamicHeight)

        let response = LayoutSettingsScene
            .GetLayoutConfiguration
            .Response(layoutConfiguration: layoutConfiguration)

        presenter?.presentLayoutConfiguration(response: response)
    }
}
