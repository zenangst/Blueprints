import UIKit

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
                var iconsImage: UIImage?
            }
            var displayedExampleSections: [DisplayedExampleSection]?
        }
    }
}
