import XCTest
import Blueprints

class HorizontalBlueprintLayoutTests: XCTestCase {
  let dataSource = MockDataSource()
  var collectionView: CollectionView!
  var horizontalLayout: HorizontalBlueprintLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createHorizontalLayout(dataSource: dataSource)
    self.collectionView = collectionView
    self.horizontalLayout = layout
  }

  func testHorizontalLayoutAttributes() {
    horizontalLayout.prepare()

    let expectedSize: CGSize = .init(width: 50, height: 50)

    XCTAssertEqual(horizontalLayout.layoutAttributes?[0].count, 10)
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 50, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 110, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 170, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 230, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 290, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 350, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 410, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 470, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 530, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 590, y: 10), size: expectedSize))

    XCTAssertNil(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(horizontalLayout.collectionViewContentSize, CGSize(width: 690, height: 70))
    XCTAssertEqual(horizontalLayout.contentSize, horizontalLayout.collectionViewContentSize)

    #if !os(macOS)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 50, y: 0), size: .init(width: 50, height: 50)))?.count, 1)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 75, y: 0), size: .init(width: 50, height: 50)))?.count, 2)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 100, y: 0), size: .init(width: 50, height: 50)))?.count, 1)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: CGRect(origin: .zero, size: .init(width: 640, height: 50)))?.count, 10)
    #endif
  }

  func testHorizontalLayoutAttributesWithItemsPerRow() {
    horizontalLayout.itemsPerColumn = 2
    horizontalLayout.prepare()

    let expectedSize: CGSize = .init(width: 50, height: 50)

    XCTAssertEqual(horizontalLayout.layoutAttributes?[0].count, 10)
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 50, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 50, y: 70), size: expectedSize))

    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 110, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 110, y: 70), size: expectedSize))

    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 170, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 170, y: 70), size: expectedSize))

    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 230, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 230, y: 70), size: expectedSize))

    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 290, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 290, y: 70), size: expectedSize))

    XCTAssertNil(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(horizontalLayout.collectionViewContentSize, CGSize(width: 390, height: 140))
    XCTAssertEqual(horizontalLayout.contentSize, horizontalLayout.collectionViewContentSize)
  }

  func testhorizontalLayoutAttributesWithSpanOne() {
    horizontalLayout.itemsPerRow = 1
    horizontalLayout.prepare()

    XCTAssertEqual(horizontalLayout.layoutAttributes?[0].count, 10)

    let expectedSize: CGSize = .init(width: 100, height: 50)

    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 50, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 160, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 270, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 380, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 490, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 600, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 710, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 820, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 930, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 1040, y: 10), size: expectedSize))

    XCTAssertNil(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(horizontalLayout.collectionViewContentSize, CGSize(width: 1190, height: 70))
    XCTAssertEqual(horizontalLayout.contentSize, horizontalLayout.collectionViewContentSize)
  }

  func testhorizontalLayoutAttributesWithSpanTwo() {
    horizontalLayout.itemsPerRow = 2
    horizontalLayout.prepare()

    let expectedSize: CGSize = .init(width: 45, height: 50)

    XCTAssertEqual(horizontalLayout.layoutAttributes?[0].count, 10)

    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 50, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 160, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 215, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 270, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 325, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 380, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 435, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 490, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 545, y: 10), size: expectedSize))

    XCTAssertNil(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(horizontalLayout.collectionViewContentSize, CGSize(width: 640, height: 70))
    XCTAssertEqual(horizontalLayout.contentSize, horizontalLayout.collectionViewContentSize)
  }

  func testhorizontalLayoutAttributesWithSpanThree() {
    horizontalLayout.itemsPerRow = 3
    horizontalLayout.prepare()

    let expectedSize: CGSize = .init(width: 26, height: 50)

    XCTAssertEqual(horizontalLayout.layoutAttributes?[0].count, 10)

    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 50, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 86, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 122, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 158, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 194, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 230, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 266, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 302, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 338, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 374, y: 10), size: expectedSize))

    XCTAssertNil(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(horizontalLayout.collectionViewContentSize, CGSize(width: 450, height: 70))
    XCTAssertEqual(horizontalLayout.contentSize, horizontalLayout.collectionViewContentSize)
  }

  func testhorizontalLayoutAttributesWithSpanFour() {
    horizontalLayout.itemsPerRow = 4
    horizontalLayout.prepare()

    let expectedSize: CGSize = .init(width: 17, height: 50)

    XCTAssertEqual(horizontalLayout.layoutAttributes?[0].count, 10)

    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 50, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 77, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 104, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 131, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 158, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 185, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 212, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 239, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 266, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 293, y: 10), size: expectedSize))

    XCTAssertNil(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(horizontalLayout.collectionViewContentSize, CGSize(width: 360, height: 70))
    XCTAssertEqual(horizontalLayout.contentSize, horizontalLayout.collectionViewContentSize)
  }
}
