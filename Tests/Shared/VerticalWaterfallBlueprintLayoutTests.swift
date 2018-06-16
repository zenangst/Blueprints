import XCTest
import Blueprints

class VerticalWaterfallBlueprintLayoutTests: XCTestCase {
  let delegate = MockDelegate()
  let dataSource = MockDataSource()
  var collectionView: CollectionView!
  var layout: VerticalWaterfallBlueprintLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createVerticalWaterfallLayout(dataSource: dataSource)
    self.collectionView = collectionView
    collectionView.delegate = delegate
    self.layout = layout
  }

  func testMosaicLayout() {
    layout.prepare()

    XCTAssertEqual(layout.cachedAttributes[0].count, 10)
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame,
                   CGRect(origin: .init(x: 2, y: 2), size: CGSize(width: 97, height: 275)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame,
                   CGRect(origin: .init(x: 101, y: 2), size: CGSize(width: 97, height: 200)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame,
                   CGRect(origin: .init(x: 101, y: 204), size: CGSize(width: 97, height: 275)))

    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame,
                   CGRect(origin: .init(x: 2, y: 279), size: CGSize(width: 97, height: 200)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame,
                   CGRect(origin: .init(x: 2, y: 481), size: CGSize(width: 97, height: 275)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame,
                   CGRect(origin: .init(x: 101, y: 481), size: CGSize(width: 97, height: 200)))

    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame,
                   CGRect(origin: .init(x: 101, y: 683), size: CGSize(width: 97, height: 275)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame,
                   CGRect(origin: .init(x: 2, y: 758), size: CGSize(width: 97, height: 200)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame,
                   CGRect(origin: .init(x: 2, y: 960), size: CGSize(width: 97, height: 275)))
  }
}
