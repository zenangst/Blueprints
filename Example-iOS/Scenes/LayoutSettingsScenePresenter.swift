protocol LayoutSettingsScenePresentationLogic {

    func presentLayoutConfiguration(response: LayoutSettingsScene.GetLayoutConfiguration.Response)
}

class LayoutSettingsScenePresenter: LayoutSettingsScenePresentationLogic {
    
    weak var viewController: LayoutSettingsSceneDisplayLogic?
}

extension LayoutSettingsScenePresenter {

    func presentLayoutConfiguration(response: LayoutSettingsScene.GetLayoutConfiguration.Response) {
        let noDecimalPlacesFormat = "%.0f"
        let oneDecimalPlacesFormat = "%.1f"
        let layoutConfiguration = response.layoutConfiguration

        let itemsPerRow = String(format: oneDecimalPlacesFormat, (layoutConfiguration.itemsPerRow) ?? (0))
        let itemsPerCollumn = String((layoutConfiguration.itemsPerCollumn) ?? (0))
        let minimumInteritemSpacing = String(format: noDecimalPlacesFormat, (layoutConfiguration.minimumInteritemSpacing) ?? (0))
        let minimumLineSpacing = String(format: noDecimalPlacesFormat, (layoutConfiguration.minimumLineSpacing) ?? (0))
        let topSectionInset = String(format: noDecimalPlacesFormat, (layoutConfiguration.sectionInsets?.top) ?? (0))
        let leftSectionInset = String(format: noDecimalPlacesFormat, (layoutConfiguration.sectionInsets?.left) ?? (0))
        let bottomSectionInset = String(format: noDecimalPlacesFormat, (layoutConfiguration.sectionInsets?.bottom) ?? (0))
        let rightSectionInset = String(format: noDecimalPlacesFormat, (layoutConfiguration.sectionInsets?.right) ?? (0))

        let viewModel = LayoutSettingsScene.GetLayoutConfiguration.ViewModel(itemsPerRow: itemsPerRow,
                                                                             itemsPerCollumn: itemsPerCollumn,
                                                                             minimumInteritemSpacing: minimumInteritemSpacing,
                                                                             minimumLineSpacing: minimumLineSpacing,
                                                                             topSectionInset: topSectionInset,
                                                                             leftSectionInset: leftSectionInset,
                                                                             bottomSectionInset: bottomSectionInset,
                                                                             rightSectionInset: rightSectionInset,
                                                                             dynamicCellHeightEnabled: layoutConfiguration.useDynamicHeight)

        viewController?.presentLayoutConfiguration(viewModel: viewModel)
    }
}
