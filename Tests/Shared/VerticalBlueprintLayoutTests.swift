import XCTest
@testable import Blueprints

class VerticalBlueprintLayoutTests: XCTestCase {
  let dataSource = MockDataSource(numberOfItems: 10, numberOfSections: 2)
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

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 500))
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

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 1220))
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

    XCTAssertEqual(layout.collectionViewContentSize, CGSize(width: 200, height: 1320))
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

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 620))
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

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 720))
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

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 500))
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

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 600))
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

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 380))
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

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 480))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWithHeaderAndFooter() {
    verticalLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 100)
    verticalLayout.footerReferenceSize = CGSize(width: collectionView.frame.width, height: 100)
    verticalLayout.prepare()

    let expectedHeaderAndFooterSize: CGSize = .init(width: 200, height: 100)
    let expectedCellSize: CGSize = .init(width: 50, height: 50)

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributes.count, 4)

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0].count, 2)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][0].frame, CGRect(origin: .init(x: 0, y: 0), size: expectedHeaderAndFooterSize))
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][1].frame, CGRect(origin: .init(x: 0, y: 350), size: expectedHeaderAndFooterSize))

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][0].min, 0)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][0].max, 250)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][1].min, 100)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][1].max, 350)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0].count, 2)
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

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1].count, 2)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][0].frame, CGRect(origin: .init(x: 0, y: 450), size: expectedHeaderAndFooterSize))
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][1].frame, CGRect(origin: .init(x: 0, y: 800), size: expectedHeaderAndFooterSize))

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][0].min, 450)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][0].max, 700)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][1].min, 550)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][1].max, 800)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[1].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 560), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 1))?.frame, CGRect(origin: .init(x: 70, y: 560), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 1))?.frame, CGRect(origin: .init(x: 130, y: 560), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 620), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 1))?.frame, CGRect(origin: .init(x: 70, y: 620), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 1))?.frame, CGRect(origin: .init(x: 130, y: 620), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 680), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 1))?.frame, CGRect(origin: .init(x: 70, y: 680), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 1))?.frame, CGRect(origin: .init(x: 130, y: 680), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 740), size: expectedCellSize))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 1)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 900))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWithStickyHeaderAndFooter() {
    verticalLayout.stickyHeaders = true
    verticalLayout.stickyFooters = true
    verticalLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 100)
    verticalLayout.footerReferenceSize = CGSize(width: collectionView.frame.width, height: 100)
    verticalLayout.prepare()

    let expectedHeaderAndFooterSize: CGSize = .init(width: 200, height: 100)
    let expectedCellSize: CGSize = .init(width: 50, height: 50)

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributes.count, 4)

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0].count, 2)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][0].frame, CGRect(origin: .init(x: 0, y: 0), size: expectedHeaderAndFooterSize))
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][1].frame, CGRect(origin: .init(x: 0, y: 100), size: expectedHeaderAndFooterSize))

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][0].min, 0)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][0].max, 250)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][1].min, 100)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0][1].max, 350)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[0].count, 2)
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

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1].count, 2)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][0].frame, CGRect(origin: .init(x: 0, y: 450), size: expectedHeaderAndFooterSize))
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][1].frame, CGRect(origin: .init(x: 0, y: 800), size: expectedHeaderAndFooterSize))

    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][0].min, 450)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][0].max, 700)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][1].min, 550)
    XCTAssertEqual(verticalLayout.cachedSupplementaryAttributesBySection[1][1].max, 800)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[1].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 560), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 1))?.frame, CGRect(origin: .init(x: 70, y: 560), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 1))?.frame, CGRect(origin: .init(x: 130, y: 560), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 620), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 1))?.frame, CGRect(origin: .init(x: 70, y: 620), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 1))?.frame, CGRect(origin: .init(x: 130, y: 620), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 680), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 1))?.frame, CGRect(origin: .init(x: 70, y: 680), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 1))?.frame, CGRect(origin: .init(x: 130, y: 680), size: expectedCellSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 740), size: expectedCellSize))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 1)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 900))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWhenScrollingWithStickyHeaderAndFooter() {
    verticalLayout.stickyHeaders = true
    verticalLayout.stickyFooters = true
    verticalLayout.headerReferenceSize = CGSize(width: 100, height: 100)
    verticalLayout.footerReferenceSize = CGSize(width: 100, height: 100)
    verticalLayout.prepare()
  }

  /// Process 1 million items in less than five seconds
  func testPerformance() {
    let dataSource = MockDataSource(numberOfItems: 10000, numberOfSections: 100)
    let (collectionView, layout) = Helper.createVerticalLayout(dataSource: dataSource)

    let startTime = CFAbsoluteTimeGetCurrent()
    layout.prepare()
    let diffTime = CFAbsoluteTimeGetCurrent() - startTime

    XCTAssertTrue(diffTime < 5)

    Swift.print("⏱ \(diffTime)")
  }
}
