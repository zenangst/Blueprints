protocol LayoutExampleSceneBusinessLogic {

    func getExampleData(request: LayoutExampleScene.GetExampleData.Request)
    func getLayoutConfiguration(request: LayoutExampleScene.GetLayoutConfiguration.Request)
}

protocol LayoutExampleSceneDataStore {

}

class LayoutExampleSceneInteractor: LayoutExampleSceneBusinessLogic, LayoutExampleSceneDataStore {

    var presenter: LayoutExampleScenePresentationLogic?
    var worker: LayoutExampleSceneWorker?
}

extension LayoutExampleSceneInteractor {

    func getExampleData(request: LayoutExampleScene.GetExampleData.Request) {
        let exampleSections = worker?.buildExampleData(
            forNumberOfSections: request.numberOfSections,
            numberOfRowsInSection: request.numberOfRowsInSection)

        let response = LayoutExampleScene
            .GetExampleData
            .Response(exampleSections: exampleSections)

        presenter?.presentExampleData(response: response)
    }

    func getLayoutConfiguration(request: LayoutExampleScene.GetLayoutConfiguration.Request) {
        let layoutConfiguration = LayoutConfiguration(
            itemsPerRow: Constants.ExampleLayoutDefaults.itemsPerRow,
            itemsPerCollumn: Constants.ExampleLayoutDefaults.itemsPerColumn,
            minimumInteritemSpacing: Constants.ExampleLayoutDefaults.minimumInteritemSpacing,
            minimumLineSpacing: Constants.ExampleLayoutDefaults.minimumLineSpacing,
            sectionInsets: Constants.ExampleLayoutDefaults.sectionInsets,
            useDynamicHeight: Constants.ExampleLayoutDefaults.useDynamicHeight)

        let response = LayoutExampleScene
            .GetLayoutConfiguration
            .Response(layoutConfiguration: layoutConfiguration)

        presenter?.presentLayoutConfiguration(response: response)
    }
}
