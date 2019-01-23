protocol LayoutExampleScenePresentationLogic {

    func presentExampleData(response: LayoutExampleScene.GetExampleData.Response)
    func presentLayoutConfiguration(response: LayoutExampleScene.GetLayoutConfiguration.Response)
}

class LayoutExampleScenePresenter: LayoutExampleScenePresentationLogic {

    weak var viewController: LayoutExampleSceneDisplayLogic?
}

extension LayoutExampleScenePresenter {

    func presentExampleData(response: LayoutExampleScene.GetExampleData.Response) {
        guard let exampleSections = response.exampleSections else {
            return
        }
        var displayedExampleSections = [LayoutExampleScene.GetExampleData.ViewModel.DisplayedExampleSection]()
        for section in exampleSections {
            guard let contents = section.contents else {
                continue
            }
            var displayedExampleSection = LayoutExampleScene.GetExampleData.ViewModel.DisplayedExampleSection(title: section.sectionTitle,
                                                                                                              contents: [LayoutExampleScene.GetExampleData.ViewModel.DisplayedExampleContent]())
            for content in contents {
                let displayedExampleContent = LayoutExampleScene.GetExampleData.ViewModel.DisplayedExampleContent(title: content.title,
                                                                                                                  message: content.message,
                                                                                                                  iconsImage: content.iconImage)
                displayedExampleSection.contents?.append(displayedExampleContent)
            }
            displayedExampleSections.append(displayedExampleSection)
        }
        let viewModel = LayoutExampleScene.GetExampleData.ViewModel(displayedExampleSections: displayedExampleSections)
        viewController?.displayExampleData(viewModel: viewModel)
    }

    func presentLayoutConfiguration(response: LayoutExampleScene.GetLayoutConfiguration.Response) {
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

        let viewModel = LayoutExampleScene.GetLayoutConfiguration.ViewModel(itemsPerRow: itemsPerRow,
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
