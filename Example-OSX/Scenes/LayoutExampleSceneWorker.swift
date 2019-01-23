class LayoutExampleSceneWorker {

    func buildExampleData(forNumberOfSections sections: Int, numberOfRowsInSection rows: Int) -> [ExampleSection]? {
        let exampleData = ExampleDataMocks(numberOfSections: sections,
                                           numberOfRowsInSection: rows)
        return exampleData.sections
    }
}
