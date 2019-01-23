import Cocoa

struct Constants {

    enum xibIdentifiers: String {
        case layoutExampleScene = "LayoutExample"
    }

    enum CollectionViewItemIdentifiers: String {
        case layoutExampleItem = "LayoutExampleCollectionViewItem"
        case titleViewElement = "TitleCollectionViewElement"
    }

    struct ExampleLayoutDefaults {
        static let itemsPerRow: CGFloat = 2
        static let itemsPerColumn: Int = 1
        static let minimumInteritemSpacing: CGFloat = 10
        static let minimumLineSpacing: CGFloat = 10
        static let sectionInsets: NSEdgeInsets = NSEdgeInsets(top: 10,
                                                              left: 10,
                                                              bottom: 10,
                                                              right: 10)
        static let useDynamicHeight = false
    }
}
