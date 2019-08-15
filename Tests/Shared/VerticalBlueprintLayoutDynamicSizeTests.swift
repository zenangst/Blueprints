import XCTest
import Blueprints

class VerticalBlueprintLayoutDynamicSizeTests: XCTestCase {
  let dataSource = MockDataSource(numberOfItems: 10, numberOfSections: 2)
  var collectionView: CollectionView!
  var verticalLayout: VerticalBlueprintLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createVerticalLayout(dataSource: dataSource)
    self.collectionView = collectionView
    self.collectionView.delegate = self
    self.verticalLayout = layout
  }
}

extension VerticalBlueprintLayoutDynamicSizeTests {

  func testVerticalLayoutAttributesWithSpanOneAndDynamicHeight() {
    verticalLayout.itemsPerRow = 1
    verticalLayout.prepare()

    let expectedWidth: CGFloat = 180

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 10), size: CGSize(width: expectedWidth, height: TestData.cellHeights[0])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 70), size: CGSize(width: expectedWidth, height: TestData.cellHeights[1])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 120), size: CGSize(width: expectedWidth, height: TestData.cellHeights[2])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 205), size: CGSize(width: expectedWidth, height: TestData.cellHeights[3])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 265), size: CGSize(width: expectedWidth, height: TestData.cellHeights[4])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 310), size: CGSize(width: expectedWidth, height: TestData.cellHeights[5])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 410), size: CGSize(width: expectedWidth, height: TestData.cellHeights[6])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 500), size: CGSize(width: expectedWidth, height: TestData.cellHeights[7])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 535), size: CGSize(width: expectedWidth, height: TestData.cellHeights[8])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 595), size: CGSize(width: expectedWidth, height: TestData.cellHeights[9])))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[1].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 640), size: CGSize(width: expectedWidth, height: TestData.cellHeights[0])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 700), size: CGSize(width: expectedWidth, height: TestData.cellHeights[1])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 750), size: CGSize(width: expectedWidth, height: TestData.cellHeights[2])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 835), size: CGSize(width: expectedWidth, height: TestData.cellHeights[3])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 895), size: CGSize(width: expectedWidth, height: TestData.cellHeights[4])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 940), size: CGSize(width: expectedWidth, height: TestData.cellHeights[5])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 1040), size: CGSize(width: expectedWidth, height: TestData.cellHeights[6])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 1130), size: CGSize(width: expectedWidth, height: TestData.cellHeights[7])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 1165), size: CGSize(width: expectedWidth, height: TestData.cellHeights[8])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 1225), size: CGSize(width: expectedWidth, height: TestData.cellHeights[9])))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 1)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 1260))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttibutesWithSpanTwoAndDynamicHeight() {
    verticalLayout.itemsPerRow = 2
    verticalLayout.prepare()

    let expectedWidth: CGFloat = 85

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 10), size: CGSize(width: expectedWidth, height: TestData.cellHeights[0])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 10), size: CGSize(width: expectedWidth, height: TestData.cellHeights[1])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 60), size: CGSize(width: expectedWidth, height: TestData.cellHeights[2])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 70), size: CGSize(width: expectedWidth, height: TestData.cellHeights[3])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 130), size: CGSize(width: expectedWidth, height: TestData.cellHeights[4])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 145), size: CGSize(width: expectedWidth, height: TestData.cellHeights[5])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 175), size: CGSize(width: expectedWidth, height: TestData.cellHeights[6])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 245), size: CGSize(width: expectedWidth, height: TestData.cellHeights[7])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 265), size: CGSize(width: expectedWidth, height: TestData.cellHeights[8])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 105, y: 280), size: CGSize(width: expectedWidth, height: TestData.cellHeights[9])))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[1].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 335.0), size: CGSize(width: expectedWidth, height: TestData.cellHeights[0])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 335.0), size: CGSize(width: expectedWidth, height: TestData.cellHeights[1])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 385.0), size: CGSize(width: expectedWidth, height: TestData.cellHeights[2])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 395.0), size: CGSize(width: expectedWidth, height: TestData.cellHeights[3])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 455.0), size: CGSize(width: expectedWidth, height: TestData.cellHeights[4])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 470.0), size: CGSize(width: expectedWidth, height: TestData.cellHeights[5])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 500.0), size: CGSize(width: expectedWidth, height: TestData.cellHeights[6])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 570.0), size: CGSize(width: expectedWidth, height: TestData.cellHeights[7])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 590.0), size: CGSize(width: expectedWidth, height: TestData.cellHeights[8])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 605.0), size: CGSize(width: expectedWidth, height: TestData.cellHeights[9])))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 1)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 650))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testVerticalLayoutAttributesWithSpanThreeAndDynamicHeight() {
    verticalLayout.itemsPerRow = 3
    verticalLayout.prepare()

    let expectedWidth: CGFloat = 53

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 10), size: CGSize(width: expectedWidth, height: TestData.cellHeights[0])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 73, y: 10), size: CGSize(width: expectedWidth, height: TestData.cellHeights[1])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 136, y: 10), size: CGSize(width: expectedWidth, height: TestData.cellHeights[2])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 73, y: 60), size: CGSize(width: expectedWidth, height: TestData.cellHeights[3])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 70), size: CGSize(width: expectedWidth, height: TestData.cellHeights[4])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 136, y: 95), size: CGSize(width: expectedWidth, height: TestData.cellHeights[5])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 115), size: CGSize(width: expectedWidth, height: TestData.cellHeights[6])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 73, y: 120), size: CGSize(width: expectedWidth, height: TestData.cellHeights[7])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 73, y: 155), size: CGSize(width: expectedWidth, height: TestData.cellHeights[8])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 136, y: 195), size: CGSize(width: expectedWidth, height: TestData.cellHeights[9])))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[1].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 240), size: CGSize(width: expectedWidth, height: TestData.cellHeights[0])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 1))?.frame, CGRect(origin: .init(x: 73, y: 240), size: CGSize(width: expectedWidth, height: TestData.cellHeights[1])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 1))?.frame, CGRect(origin: .init(x: 136, y: 240), size: CGSize(width: expectedWidth, height: TestData.cellHeights[2])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 1))?.frame, CGRect(origin: .init(x: 73, y: 290), size: CGSize(width: expectedWidth, height: TestData.cellHeights[3])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 300), size: CGSize(width: expectedWidth, height: TestData.cellHeights[4])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 1))?.frame, CGRect(origin: .init(x: 136, y: 325), size: CGSize(width: expectedWidth, height: TestData.cellHeights[5])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 345), size: CGSize(width: expectedWidth, height: TestData.cellHeights[6])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 1))?.frame, CGRect(origin: .init(x: 73, y: 350), size: CGSize(width: expectedWidth, height: TestData.cellHeights[7])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 1))?.frame, CGRect(origin: .init(x: 73, y: 385), size: CGSize(width: expectedWidth, height: TestData.cellHeights[8])))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 1))?.frame, CGRect(origin: .init(x: 136, y: 425), size: CGSize(width: expectedWidth, height: TestData.cellHeights[9])))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 1)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 460))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }
}

extension VerticalBlueprintLayoutDynamicSizeTests: CollectionViewFlowLayoutDelegate {

  struct TestData {
    static let cellHeights: [CGFloat] = [
      50,
      40,
      75,
      50,
      35,
      90,
      80,
      25,
      50,
      25
    ]
  }

  func collectionView(_ collectionView: CollectionView, layout collectionViewLayout: CollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    #if os(macOS)
    return CGSize(width: 85, height: TestData.cellHeights[indexPath.item])
    #else
    return CGSize(width: 85, height: TestData.cellHeights[indexPath.row])
    #endif
  }
}
