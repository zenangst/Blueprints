struct ExampleSection {
    var sectionTitle: String
    var contents: [ExampleContent]?

    init(title: String,
         contents: [ExampleContent]?) {
        self.sectionTitle = title
        self.contents = contents
    }
}
