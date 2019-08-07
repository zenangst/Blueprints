import XCTest
import Blueprints

class HorizontalBlueprintLayoutTests_macOS: XCTestCase {
  let dataSource = MockDataSource()
  var collectionView: CollectionView!
  var horizontalLayout: HorizontalBlueprintLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createHorizontalLayout(dataSource: dataSource)
    self.collectionView = collectionView
    self.horizontalLayout = layout
  }

  func testLayoutAttributesForElements() {
    horizontalLayout.minimumLineSpacing = 0
    horizontalLayout.minimumInteritemSpacing = 0
    horizontalLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    horizontalLayout.prepare()

    collectionView.enclosingScrollView?.frame.size = .init(width: 50, height: 50)
    collectionView.contentOffset = .init(x: 0, y: 0)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: .zero).count, 1)

    collectionView.contentOffset = .init(x: 75, y: 0)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: collectionView.enclosingScrollView!.documentVisibleRect).count, 2)

    collectionView.contentOffset = .init(x: 100, y: 0)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: collectionView.enclosingScrollView!.documentVisibleRect).count, 3)

    collectionView.enclosingScrollView?.frame.size = CGSize(width: 500, height: 500)
    collectionView.contentOffset = .init(x: 0, y: 0)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: collectionView.enclosingScrollView!.documentVisibleRect).count, 10)
  }
}
