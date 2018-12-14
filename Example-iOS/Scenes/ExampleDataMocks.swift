import Foundation

class ExampleDataMocks {

    var sections: [ExampleSection]?

    init(numberOfSections sections: Int, numberOfRowsInSection rows: Int) {
        setupDummyData(numberOfSections: sections, numberOfRowsInSection: rows)
    }
}

private extension ExampleDataMocks {

    func setupDummyData(numberOfSections sectionCount: Int, numberOfRowsInSection rowCount: Int) {
        var exampleSections = [ExampleSection]()
        for index in 1...sectionCount {
            let title = NSLocalizedString("Section \(index)", comment: "Section title with index")
            let exampleSection = createExampleSection(withTitle: title,
                                                      andNumberOfRows: rowCount)
            exampleSections.append(exampleSection)
        }
        sections = exampleSections
    }

    func createExampleSection(withTitle title: String, andNumberOfRows rowCount: Int) -> ExampleSection {
        var sectionContents = [ExampleContent]()
        for index in 1...rowCount {
            let contentTitle = NSLocalizedString("Title \(index)", comment: "Contents title with index")
            let exampleContent = createExampleContent(withTitle: contentTitle)
            sectionContents.append(exampleContent)
        }
        let exampleSection = ExampleSection(title: title,
                                            contents: sectionContents)
        return exampleSection
    }

    func createExampleContent(withTitle title: String) -> ExampleContent {
        let message = Lorem.tweet
        let exampleContent = ExampleContent(title: title,
                                            message: message,
                                            iconImage: nil)
        return exampleContent
    }
}
