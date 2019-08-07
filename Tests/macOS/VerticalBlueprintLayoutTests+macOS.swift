import XCTest
import Blueprints

class VerticalBlueprintLayoutTests_macOS: XCTestCase {
  let dataSource = MockDataSource()
  var collectionView: CollectionView!
  var verticalLayout: VerticalBlueprintLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createVerticalLayout(dataSource: dataSource)
    self.collectionView = collectionView
    self.verticalLayout = layout
  }

  func testLayoutAttributesForElements() {
    verticalLayout.minimumLineSpacing = 0
    verticalLayout.minimumInteritemSpacing = 0
    verticalLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    verticalLayout.prepare()

    collectionView.enclosingScrollView?.frame.size = .init(width: 50, height: 50)
    collectionView.contentOffset = .init(x: 0, y: 0)
    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: collectionView.enclosingScrollView!.documentVisibleRect).count, 8)

    collectionView.contentOffset = .init(x: 0, y: 25)
    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: collectionView.enclosingScrollView!.documentVisibleRect).count, 8)

    collectionView.contentOffset = .init(x: 0, y: 50)
    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: collectionView.enclosingScrollView!.documentVisibleRect).count, 10)

    collectionView.enclosingScrollView?.frame.size = CGSize(width: 500, height: 500)
    collectionView.contentOffset = .init(x: 0, y: 0)
    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: collectionView.enclosingScrollView!.documentVisibleRect).count, 10)
  }
}

