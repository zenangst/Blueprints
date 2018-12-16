protocol LayoutExampleScenePresentationLogic {

    func presentExampleData(response: LayoutExampleScene.GetExampleData.Response)
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
}
