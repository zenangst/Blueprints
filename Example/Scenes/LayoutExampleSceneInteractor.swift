protocol LayoutExampleSceneBusinessLogic {

    func getExampleData(request: LayoutExampleScene.GetExampleData.Request)
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
}
