import Blueprints
import Cocoa

class MockDelegate: NSObject, NSCollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
    let height = indexPath.item % 2 == 1 ? 200 : 275
    return CGSize(width: 200, height: height)
  }
}

class Helper {
  static func createHorizontalLayout(dataSource: NSCollectionViewDataSource, withItemsPerRow: CGFloat = 0.0) -> (collectionView: CollectionView, layout: HorizontalBlueprintLayout) {
    let frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
    let scrollView = NSScrollView()
    let window = NSWindow()
    scrollView.frame = frame
    window.setFrame(frame, display: true)

    let layout: HorizontalBlueprintLayout

    if withItemsPerRow > 0.0 {
      layout = HorizontalBlueprintLayout(
        itemsPerRow: withItemsPerRow,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: EdgeInsets(top: 10, left: 50, bottom: 10, right: 50))
    } else {
      layout = HorizontalBlueprintLayout(
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: EdgeInsets(top: 10, left: 50, bottom: 10, right: 50))
    }

    layout.itemSize = CGSize(width: 50, height: 50)
    layout.estimatedItemSize = CGSize(width: 50, height: 50)
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.register(MockCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "cell"))
    collectionView.dataSource = dataSource
    scrollView.documentView = collectionView
    window.contentView = scrollView

    return (collectionView: collectionView, layout: layout)
  }

  static func createVerticalLayout(dataSource: NSCollectionViewDataSource, withItemsPerRow: CGFloat = 0.0) -> (collectionView: CollectionView, layout: VerticalBlueprintLayout) {
    let frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
    let scrollView = NSScrollView()
    let window = NSWindow()
    window.setFrame(frame, display: true)
    scrollView.frame = frame

    let layout: VerticalBlueprintLayout

    if withItemsPerRow > 0.0 {
      layout = VerticalBlueprintLayout(
        itemsPerRow: withItemsPerRow,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    } else {
      layout = VerticalBlueprintLayout(
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    layout.itemSize = CGSize(width: 50, height: 50)
    layout.estimatedItemSize = CGSize(width: 50, height: 50)
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.register(MockCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "cell"))
    collectionView.dataSource = dataSource
    scrollView.documentView = collectionView
    window.contentView = scrollView

    return (collectionView: collectionView, layout: layout)
  }

  static func createVerticalMosaicLayout(dataSource: NSCollectionViewDataSource) -> (collectionView: CollectionView, layout: VerticalMosaicBlueprintLayout) {
    let frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
    let scrollView = NSScrollView()
    let window = NSWindow()
    window.setFrame(frame, display: true)
    scrollView.frame = frame

    let patterns = [
      MosaicPattern(alignment: .left, direction: .vertical, amount: 2, multiplier: 0.5),
      MosaicPattern(alignment: .left, direction: .horizontal, amount: 2, multiplier: 0.5),
      MosaicPattern(alignment: .right, direction: .vertical, amount: 2, multiplier: 0.5)
    ]

    let layout = VerticalMosaicBlueprintLayout(
      minimumInteritemSpacing: 2,
      minimumLineSpacing: 2,
      sectionInset: EdgeInsets(top: 2, left: 2, bottom: 2, right: 2),
      patterns: patterns)
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
