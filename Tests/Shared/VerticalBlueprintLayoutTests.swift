import XCTest
import Blueprints

class VerticalBlueprintLayoutTests: XCTestCase {
  let dataSource = MockDataSource(numberOfItems: 10)
  var collectionView: CollectionView!
  var verticalLayout: VerticalBlueprintLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createVerticalLayout(dataSource: dataSource)
    self.collectionView = collectionView
    self.verticalLayout = layout
  }

  func testVerticalLayoutAttributes() {
    verticalLayout.prepare()

    let expectedSize: CGSize = .init(width: 50, height: 50)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)
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
  }

  func testVerticalLayoutAttributesWithSpanOne() {
    verticalLayout.itemsPerRow = 1
    verticalLayout.prepare()

    let expectedSize: CGSize = .init(width: 180, height: 50)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)

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

  func testVerticalLayoutAttributesWithSpanOneUsingSectionHeaders() {
    let (collectionView, layout) = Helper.createVerticalLayout(dataSource: dataSource, withItemsPerRow: 1.0)
    _ = collectionView.frame
    layout.headerReferenceSize = CGSize(width: 200, height: 50)
    layout.prepare()

    let expectedHeaderSize: CGSize = .init(width: 200, height: 50)
    let expectedCellSize: CGSize = .init(width: 180, height: 50)

    XCTAssertEqual(layout.cachedSupplementaryAttributesBySection[0].count, 1)
    XCTAssertEqual(layout.cachedItemAttributesBySection[0].count, 10)

    XCTAssertEqual(layout.layoutAttributesForSupplementaryView(ofKind: CollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 0, y: 0), size: expectedHeaderSize))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 60), size: expectedCellSize))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 120), size: expectedCellSize))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 180), size: expectedCellSize))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 240), size: expectedCellSize))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 300), size: expectedCellSize))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 360), size: expectedCellSize))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 420), size: expectedCellSize))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 480), size: expectedCellSize))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 540), size: expectedCellSize))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 600), size: expectedCellSize))

    XCTAssertNil(layout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(layout.collectionViewContentSize, CGSize(width: 200, height: 660))
    XCTAssertEqual(layout.contentSize, layout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWithSpanTwo() {
    verticalLayout.itemsPerRow = 2
    verticalLayout.prepare()

    let expectedSize: CGSize = .init(width: 85, height: 50)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)

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

  func testVerticalLayoutAttributesWithSpanTwoUsingSectionHeaders() {
    verticalLayout.itemsPerRow = 2
    verticalLayout.headerReferenceSize = CGSize(width: 200, height: 50)
    verticalLayout.prepare()

    let expectedHeaderSize: CGSize = .init(width: 200, height: 50)
    let expectedCellSize: CGSize = .init(width: 85, height: 50)

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0].count, 1)
    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)

    XCTAssertEqual(verticalLayout.layoutAttributesForSupplementaryView(ofKind: CollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 0, y: 0), size: expectedHeaderSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 60), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 60), size: expectedCellSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 120), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 120), size: expectedCellSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 180), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 180), size: expectedCellSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 240), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 240), size: expectedCellSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 300), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 300), size: expectedCellSize))

    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 360))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWithSpanThree() {
    verticalLayout.itemsPerRow = 3
    verticalLayout.prepare()

    let expectedSize: CGSize = .init(width: 53, height: 50)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)

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

  func testVerticalLayoutAttributesWithSpanThreeUsingSectionHeaders() {
    verticalLayout.itemsPerRow = 3
    verticalLayout.headerReferenceSize = CGSize(width: 200, height: 50)
    verticalLayout.prepare()

    let expectedHeaderSize: CGSize = .init(width: 200, height: 50)
    let expectedCellSize: CGSize = .init(width: 53, height: 50)

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0].count, 1)
    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)


    XCTAssertEqual(verticalLayout.layoutAttributesForSupplementaryView(ofKind: CollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 0, y: 0), size: expectedHeaderSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 60), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 73, y: 60), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 136, y: 60), size: expectedCellSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 120), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 73, y: 120), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 136, y: 120), size: expectedCellSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 180), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 73, y: 180), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 136, y: 180), size: expectedCellSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 240), size: expectedCellSize))

    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 300))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWithSpanFour() {
    verticalLayout.itemsPerRow = 4
    verticalLayout.prepare()

    let expectedSize: CGSize = .init(width: 37, height: 50)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)

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

  func testVerticalLayoutAttributesWithSpanFourUsingSectionHeaders() {
    verticalLayout.itemsPerRow = 4
    verticalLayout.headerReferenceSize = CGSize(width: 200, height: 50)
    verticalLayout.prepare()

    let expectedHeaderSize: CGSize = .init(width: 200, height: 50)
    let expectedCellSize: CGSize = .init(width: 37, height: 50)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0].count, 1)

    XCTAssertEqual(verticalLayout.layoutAttributesForSupplementaryView(ofKind: CollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 0, y: 0), size: expectedHeaderSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 60), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 57, y: 60), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 104, y: 60), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 151, y: 60), size: expectedCellSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 120), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 57, y: 120), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 104, y: 120), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 151, y: 120), size: expectedCellSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 180), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 57, y: 180), size: expectedCellSize))

    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 240))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWithHeaderAndFooter() {
    verticalLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 100)
    verticalLayout.footerReferenceSize = CGSize(width: collectionView.frame.width, height: 100)
    verticalLayout.prepare()

    let expectedHeaderAndFooterSize: CGSize = .init(width: 200, height: 100)
    let expectedCellSize: CGSize = .init(width: 50, height: 50)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0].count, 2)

    XCTAssertEqual(verticalLayout.layoutAttributesForSupplementaryView(ofKind: CollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 0, y: 0), size: expectedHeaderAndFooterSize))

    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 110), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 70, y: 110), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 130, y: 110), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 170), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 70, y: 170), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 130, y: 170), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 230), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 70, y: 230), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 130, y: 230), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 290), size: expectedCellSize))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.layoutAttributesForSupplementaryView(ofKind: CollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 0, y: 350), size: expectedHeaderAndFooterSize))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 450))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWithStickyHeaderAndFooter() {
    verticalLayout.stickyHeaders = true
    verticalLayout.stickyFooters = true
    verticalLayout.headerReferenceSize = CGSize(width: 100, height: 100)
    verticalLayout.footerReferenceSize = CGSize(width: 100, height: 100)
    verticalLayout.prepare()

    let expectedSize: CGSize = .init(width: 50, height: 50)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0].count, 2)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 110), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 70, y: 110), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 130, y: 110), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 170), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 70, y: 170), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 130, y: 170), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 230), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 70, y: 230), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 130, y: 230), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 290), size: expectedSize))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 450))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }
}
