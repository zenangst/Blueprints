import Cocoa

enum LayoutExampleScene {

    enum GetExampleData {
        struct Request {
            var numberOfSections: Int
            var numberOfRowsInSection: Int
        }
        struct Response {
            var exampleSections: [ExampleSection]?
        }
        struct ViewModel {
            struct DisplayedExampleSection {
                var title: String
                var contents: [DisplayedExampleContent]?
            }
            struct DisplayedExampleContent {
                var title: String
                var message: String
                var iconsImage: NSImage?
            }
            var displayedExampleSections: [DisplayedExampleSection]?
        }
    }

    enum GetLayoutConfiguration {
        struct Request {

        }
        struct Response {
            var layoutConfiguration: LayoutConfiguration
        }
        struct ViewModel {
            var itemsPerRow: String?
            var itemsPerCollumn: String?
            var minimumInteritemSpacing: String?
            var minimumLineSpacing: String?
            var topSectionInset: String?
            var leftSectionInset: String?
            var bottomSectionInset: String?
            var rightSectionInset: String?
            var dynamicCellHeightEnabled: Bool?
        }
    }
}
