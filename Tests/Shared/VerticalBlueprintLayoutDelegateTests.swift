import XCTest
import Blueprints

class VerticalBlueprintLayoutDelegateTests: XCTestCase {
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

extension VerticalBlueprintLayoutDelegateTests {

  func testLayoutAttributesForElementsWithMinimumLineSpacingDelegate() {
    collectionView.delegate = self
    verticalLayout.prepare()

    guard let minimumLineSpacingAtFirstSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: verticalLayout,
      minimumLineSpacingForSectionAt: 0) else {
        return XCTFail("Expected minimumLineSpacing")
    }
    guard let minimumLineSpacingAtSecondSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: verticalLayout,
      minimumLineSpacingForSectionAt: 1) else {
        return XCTFail("Expected minimumLineSpacing")
    }

    XCTAssertEqual(minimumLineSpacingAtFirstSection, 0)
    XCTAssertEqual(minimumLineSpacingAtSecondSection, 10)

    let expectedSize: CGSize = .init(width: 50, height: 50)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 60, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 110, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 60), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 60, y: 60), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 110, y: 60), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 110), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 60, y: 110), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 110, y: 110), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 160), size: expectedSize))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[1].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 230), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 1))?.frame, CGRect(origin: .init(x: 70, y: 230), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 1))?.frame, CGRect(origin: .init(x: 130, y: 230), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 290), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 1))?.frame, CGRect(origin: .init(x: 70, y: 290), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 1))?.frame, CGRect(origin: .init(x: 130, y: 290), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 350), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 1))?.frame, CGRect(origin: .init(x: 70, y: 350), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 1))?.frame, CGRect(origin: .init(x: 130, y: 350), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 410), size: expectedSize))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 1)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 470))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }

  func testLayoutAttributesForElementsWithMinimumInteritemSpacingDelegate() {
    collectionView.delegate = self
    verticalLayout.itemsPerRow = 2
    verticalLayout.prepare()

    guard let minimumInteritemSpacingAtFirstSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: verticalLayout,
      minimumInteritemSpacingForSectionAt: 0) else {
        return XCTFail("Expected minimumLineSpacing")
    }
    guard let minimumInteritemSpacingAtSecondSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: verticalLayout,
      minimumInteritemSpacingForSectionAt: 1) else {
        return XCTFail("Expected minimumLineSpacing")
    }

    XCTAssertEqual(minimumInteritemSpacingAtFirstSection, 0)
    XCTAssertEqual(minimumInteritemSpacingAtSecondSection, 10)

    let expectedSize: CGSize = .init(width: 85, height: 50)

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 95, y: 10), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 60), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 95, y: 60), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 110), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 95, y: 110), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 160), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 95, y: 160), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 10, y: 210), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 95, y: 210), size: expectedSize))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(verticalLayout.cachedItemAttributesBySection[1].count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 280), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 280), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 340), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 340), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 400), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 400), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 460), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 460), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 1))?.frame, CGRect(origin: .init(x: 10, y: 520), size: expectedSize))
    XCTAssertEqual(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 520), size: expectedSize))
    XCTAssertNil(verticalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 1)))

    XCTAssertEqual(verticalLayout.collectionViewContentSize, CGSize(width: 200, height: 580))
    XCTAssertEqual(verticalLayout.contentSize, verticalLayout.collectionViewContentSize)
  }
}

extension VerticalBlueprintLayoutDelegateTests: CollectionViewFlowLayoutDelegate {

  func collectionView(_ collectionView: CollectionView, layout collectionViewLayout: CollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    let minimumInteritemSpacing: CGFloat = section % 2 == 1 ? 10 : 0
    return minimumInteritemSpacing
  }

  func collectionView(_ collectionView: CollectionView, layout collectionViewLayout: CollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    let minimumLineSpacing: CGFloat = section % 2 == 1 ? 10 : 0
    return minimumLineSpacing
  }
}
