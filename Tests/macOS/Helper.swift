import Blueprints
import Cocoa

class Helper {
  static func createHorizontalLayout(dataSource: NSCollectionViewDataSource) -> (collectionView: CollectionView, layout: HorizontalBlueprintLayout) {
    let frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
    let scrollView = NSScrollView()
    let window = NSWindow()
    scrollView.frame = frame
    window.setFrame(frame, display: true)
    let layout = HorizontalBlueprintLayout(
      minimumInteritemSpacing: 10,
      minimumLineSpacing: 10,
      sectionInset: EdgeInsets(top: 10, left: 50, bottom: 10, right: 50))
    layout.itemSize = CGSize(width: 50, height: 50)
    layout.estimatedItemSize = CGSize(width: 50, height: 50)
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.register(MockCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "cell"))
    collectionView.dataSource = dataSource
    scrollView.documentView = collectionView
    window.contentView = scrollView

    return (collectionView: collectionView, layout: layout)
  }

  static func createVerticalLayout(dataSource: NSCollectionViewDataSource) -> (collectionView: CollectionView, layout: VerticalBlueprintLayout) {
    let frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
    let scrollView = NSScrollView()
    let window = NSWindow()
    window.setFrame(frame, display: true)
    scrollView.frame = frame
    let layout = VerticalBlueprintLayout(
      minimumInteritemSpacing: 10,
      minimumLineSpacing: 10,
      sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    layout.itemSize = CGSize(width: 50, height: 50)
    layout.estimatedItemSize = CGSize(width: 50, height: 50)
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.register(MockCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "cell"))
    collectionView.dataSource = dataSource
    scrollView.documentView = collectionView
    window.contentView = scrollView

    return (collectionView: collectionView, layout: layout)
  }
}

