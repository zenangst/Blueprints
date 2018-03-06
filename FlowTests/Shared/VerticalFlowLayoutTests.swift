import XCTest
import Flow

class VerticalFlowLayoutTests: XCTestCase {
  let dataSource = MockDataSource(numberOfItems: 10)
  var collectionView: CollectionView!
  var verticalLayout: VerticalFlowLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createVerticalLayout(dataSource: dataSource)
    self.collectionView = collectionView
    self.verticalLayout = layout
  }

  func testVerticalLayoutAttributes() {
    verticalLayout.prepare()

    let expectedSize: CGSize = .init(width: 50, height: 50)

    XCTAssertEqual(verticalLayout.layoutAttributes?[0].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 70, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 130, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 70), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 70, y: 70), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 130, y: 70), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 130), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 70, y: 130), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 130, y: 130), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 190), size: expectedSize))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 250))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)

    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: CGRect(origin: .zero, size: .init(width: 50, height: 50)))?.count, 1)
    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 0, y: 25), size: .init(width: 50, height: 50)))?.count, 2)
    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: CGRect(origin: .zero, size: .init(width: 200, height: 200)))?.count, 10)
  }

  func testVerticalLayoutAttributesWithSpanOne() {
    verticalLayout.itemsPerRow = 1
    verticalLayout.prepare()

    XCTAssertEqual(verticalLayout.layoutAttributes?[0].count, 10)

    let expectedSize: CGSize = .init(width: 180, height: 50)

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 70), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 130), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 190), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 250), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 310), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 370), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 430), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 490), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 550), size: expectedSize))

    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 610))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWithSpanTwo() {
    verticalLayout.itemsPerRow = 2
    verticalLayout.prepare()

    let expectedSize: CGSize = .init(width: 85, height: 50)

    XCTAssertEqual(verticalLayout.layoutAttributes?[0].count, 10)

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 10), size: expectedSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 70), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 70), size: expectedSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 130), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 130), size: expectedSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 190), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 190), size: expectedSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 250), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 250), size: expectedSize))

    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 310))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWithSpanThree() {
    verticalLayout.itemsPerRow = 3
    verticalLayout.prepare()

    let expectedSize: CGSize = .init(width: 53, height: 50)

    XCTAssertEqual(verticalLayout.layoutAttributes?[0].count, 10)

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 73, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 136, y: 10), size: expectedSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 70), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 73, y: 70), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 136, y: 70), size: expectedSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 130), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 73, y: 130), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 136, y: 130), size: expectedSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 190), size: expectedSize))

    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 250))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWithSpanFour() {
    verticalLayout.itemsPerRow = 4
    verticalLayout.prepare()

    let expectedSize: CGSize = .init(width: 37, height: 50)

    XCTAssertEqual(verticalLayout.layoutAttributes?[0].count, 10)

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 57, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 104, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 151, y: 10), size: expectedSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 70), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 57, y: 70), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 104, y: 70), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 151, y: 70), size: expectedSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 130), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 57, y: 130), size: expectedSize))

    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 190))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }
}
