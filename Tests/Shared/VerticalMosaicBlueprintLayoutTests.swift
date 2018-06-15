import XCTest
import Blueprints

class VerticalMosaicBlueprintLayoutTests: XCTestCase {
  let dataSource = MockDataSource()
  var collectionView: CollectionView!
  var layout: VerticalMosaicBlueprintLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createVerticalMosaicLayout(dataSource: dataSource)
    self.collectionView = collectionView
    self.layout = layout
  }

  func testMosaicLayout() {
    layout.prepare()

    XCTAssertEqual(layout.cachedAttributes[0].count, 10)
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame,
                   CGRect(origin: .init(x: 2, y: 2), size: CGSize(width: 98, height: 23)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame,
                   CGRect(origin: .init(x: 102, y: 2), size: CGSize(width: 96, height: 10)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame,
                   CGRect(origin: .init(x: 102, y: 14), size: CGSize(width: 96, height: 10)))

    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame,
                   CGRect(origin: .init(x: 2, y: 27), size: CGSize(width: 98, height: 23)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame,
                   CGRect(origin: .init(x: 102, y: 27), size: CGSize(width: 47, height: 23)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame,
                   CGRect(origin: .init(x: 151, y: 27), size: CGSize(width: 47, height: 23)))

    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame,
                   CGRect(origin: .init(x: 100, y: 52), size: CGSize(width: 98, height: 23)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame,
                   CGRect(origin: .init(x: 2, y: 52), size: CGSize(width: 96, height: 10)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame,
                   CGRect(origin: .init(x: 2, y: 64), size: CGSize(width: 96, height: 10)))


  }
}
