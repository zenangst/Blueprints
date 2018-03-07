import Cocoa

public class MockDataSource: NSObject, NSCollectionViewDataSource {
  var numberOfItems: Int = 10

  convenience init(numberOfItems: Int = 10) {
    self.init()
    self.numberOfItems = numberOfItems
  }

  public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfItems
  }

  public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), for: indexPath)
    return cell
  }
}

public class MockCollectionViewItem: NSCollectionViewItem {
  public override func loadView() {
    self.view = NSView()
  }
}
