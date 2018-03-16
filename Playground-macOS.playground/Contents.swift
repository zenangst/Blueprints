import Cocoa
import PlaygroundSupport
import Blueprints

class Item: NSCollectionViewItem {
  override func loadView() {
    self.view = NSView()
  }
}

class DataSource: NSObject, NSCollectionViewDataSource {
  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("identifier"), for: indexPath)

    item.view.wantsLayer = true
    item.view.layer?.backgroundColor = NSColor.green.cgColor

    return item
  }

  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
}

let frame = CGRect(origin: .zero, size: .init(width: 480, height: 640))
let scrollView = NSScrollView(frame: frame)
let dataSource = DataSource()
let blueprint = HorizontalBlueprintLayout(
  itemsPerRow: 3.5,
  itemsPerColumn: 2,
  itemSize: CGSize(width: 80, height: 80),
  sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
)
let collectionView = CollectionView(frame: frame, collectionViewLayout: blueprint)

collectionView.register(Item.self,
                        forItemWithIdentifier: NSUserInterfaceItemIdentifier.init("identifier"))
collectionView.dataSource = dataSource
collectionView.backgroundColors = [NSColor.black]
scrollView.documentView = collectionView
collectionView.frame.size = blueprint.contentSize

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = scrollView
