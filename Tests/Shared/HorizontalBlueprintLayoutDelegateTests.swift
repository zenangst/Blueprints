import XCTest
import Blueprints

class HorizontalBlueprintLayoutDelegateTests: XCTestCase {
  let dataSource = MockDataSource(numberOfItems: 10, numberOfSections: 2)
  var collectionView: CollectionView!
  var horizontalLayout: HorizontalBlueprintLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createHorizontalLayout(dataSource: dataSource)
    self.collectionView = collectionView
    self.collectionView.delegate = self
    self.horizontalLayout = layout
  }
}

extension HorizontalBlueprintLayoutDelegateTests {

  func testLayoutAttributesForElementsWithMinimumLineSpacingDelegate() {
    collectionView.delegate = self
    horizontalLayout.prepare()

    guard let minimumLineSpacingAtFirstSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: horizontalLayout,
      minimumLineSpacingForSectionAt: 0) else {
        return XCTFail("Expected minimumLineSpacing")
    }
    guard let minimumLineSpacingAtSecondSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: horizontalLayout,
      minimumLineSpacingForSectionAt: 1) else {
        return XCTFail("Expected minimumLineSpacing")
    }

    XCTAssertEqual(minimumLineSpacingAtFirstSection, 0)
    XCTAssertEqual(minimumLineSpacingAtSecondSection, 10)

    let expectedSize: CGSize = .init(width: 50, height: 50)

    XCTAssertEqual(horizontalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 50, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 100, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 150, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 200, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 250, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 300, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 350, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 400, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 450, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 500, y: 10), size: expectedSize))
    XCTAssertNil(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(horizontalLayout.collectionViewContentSize, CGSize(width: 1290, height: 70))
    XCTAssertEqual(horizontalLayout.contentSize, horizontalLayout.collectionViewContentSize)
  }

  func testLayoutAttributesForElementsWithMinimumInteritemSpacingDelegate() {
    collectionView.delegate = self
    horizontalLayout.itemsPerRow = 2
    horizontalLayout.prepare()

    guard let minimumInteritemSpacingAtFirstSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: horizontalLayout,
      minimumInteritemSpacingForSectionAt: 0) else {
        return XCTFail("Expected minimumLineSpacing")
    }
    guard let minimumInteritemSpacingAtSecondSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: horizontalLayout,
      minimumInteritemSpacingForSectionAt: 1) else {
        return XCTFail("Expected minimumLineSpacing")
    }

    XCTAssertEqual(minimumInteritemSpacingAtFirstSection, 0)
    XCTAssertEqual(minimumInteritemSpacingAtSecondSection, 10)

    let expectedSize: CGSize = .init(width: 45, height: 50)

    XCTAssertEqual(horizontalLayout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 50, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 95, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 140, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 185, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 230, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 275, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 320, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 365, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 410, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 0))?.frame, CGRect(origin: .init(x: 455, y: 10), size: expectedSize))
    XCTAssertNil(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 0)))

    XCTAssertEqual(horizontalLayout.cachedItemAttributesBySection[1].count, 10)
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))?.frame, CGRect(origin: .init(x: 600, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 1, section: 1))?.frame, CGRect(origin: .init(x: 655, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 2, section: 1))?.frame, CGRect(origin: .init(x: 710, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 3, section: 1))?.frame, CGRect(origin: .init(x: 765, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 4, section: 1))?.frame, CGRect(origin: .init(x: 820, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 5, section: 1))?.frame, CGRect(origin: .init(x: 875, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 6, section: 1))?.frame, CGRect(origin: .init(x: 930, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 7, section: 1))?.frame, CGRect(origin: .init(x: 985, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 8, section: 1))?.frame, CGRect(origin: .init(x: 1040, y: 10), size: expectedSize))
    XCTAssertEqual(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 9, section: 1))?.frame, CGRect(origin: .init(x: 1095, y: 10), size: expectedSize))
    XCTAssertNil(horizontalLayout.layoutAttributesForItem(at: IndexPath(item: 10, section: 1)))

    XCTAssertEqual(horizontalLayout.collectionViewContentSize, CGSize(width: 1190, height: 70))
    XCTAssertEqual(horizontalLayout.contentSize, horizontalLayout.collectionViewContentSize)
  }
}

extension HorizontalBlueprintLayoutDelegateTests: CollectionViewFlowLayoutDelegate {

  func collectionView(_ collectionView: CollectionView, layout collectionViewLayout: CollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    let minimumInteritemSpacing: CGFloat = section % 2 == 1 ? 10 : 0
    return minimumInteritemSpacing
  }

  func collectionView(_ collectionView: CollectionView, layout collectionViewLayout: CollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    let minimumLineSpacing: CGFloat = section % 2 == 1 ? 10 : 0
    return minimumLineSpacing
  }
}
