import UIKit

enum LayoutSettingsScene {

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
