import XCTest
import Blueprints

class VerticalMosaicBlueprintLayoutDelegateTests: XCTestCase {
  let dataSource = MockDataSource(numberOfItems: 10, numberOfSections: 2)
  var collectionView: CollectionView!
  var layout: VerticalMosaicBlueprintLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createVerticalMosaicLayout(dataSource: dataSource)
    self.collectionView = collectionView
    self.collectionView.delegate = self
    self.layout = layout
  }
}

extension VerticalMosaicBlueprintLayoutDelegateTests {

  func testLayoutAttributesForElementsWithMinimumLineSpacingDelegate() {
    layout.prepare()

    guard let minimumLineSpacingAtFirstSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: layout,
      minimumLineSpacingForSectionAt: 0) else {
        return XCTFail("Expected minimumLineSpacing")
    }
    guard let minimumLineSpacingAtSecondSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: layout,
      minimumLineSpacingForSectionAt: 1) else {
        return XCTFail("Expected minimumLineSpacing")
    }

    XCTAssertEqual(minimumLineSpacingAtFirstSection, 0)
    XCTAssertEqual(minimumLineSpacingAtSecondSection, 10)

    XCTAssertEqual(layout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 2, y: 2), size: CGSize(width: 98, height: 25)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 100, y: 2), size: CGSize(width: 98, height: 12)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 100, y: 14), size: CGSize(width: 98, height: 12)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 2, y: 27), size: CGSize(width: 98, height: 25)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 100, y: 27), size: CGSize(width: 49, height: 25)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 149, y: 27), size: CGSize(width: 49, height: 25)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 100, y: 52), size: CGSize(width: 98, height: 25)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 2, y: 52), size: CGSize(width: 98, height: 12)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 2, y: 64), size: CGSize(width: 98, height: 12)))

    XCTAssertEqual(layout.collectionViewContentSize, CGSize(width: 200, height: 198))
    XCTAssertEqual(layout.contentSize, layout.collectionViewContentSize)
  }

  func testLayoutAttributesForElementsWithMinimumInteritemSpacingDelegate() {
    layout.prepare()

    guard let minimumInteritemSpacingAtFirstSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: layout,
      minimumInteritemSpacingForSectionAt: 0) else {
        return XCTFail("Expected minimumLineSpacing")
    }
    guard let minimumInteritemSpacingAtSecondSection = (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(
      collectionView,
      layout: layout,
      minimumInteritemSpacingForSectionAt: 1) else {
        return XCTFail("Expected minimumLineSpacing")
    }

    XCTAssertEqual(minimumInteritemSpacingAtFirstSection, 0)
    XCTAssertEqual(minimumInteritemSpacingAtSecondSection, 10)

    XCTAssertEqual(layout.cachedItemAttributesBySection[0].count, 10)
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame, CGRect(origin: .init(x: 2, y: 2), size: CGSize(width: 98, height: 25)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame, CGRect(origin: .init(x: 100, y: 2), size: CGSize(width: 98, height: 12)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 2, section: 0))?.frame, CGRect(origin: .init(x: 100, y: 14), size: CGSize(width: 98, height: 12)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 3, section: 0))?.frame, CGRect(origin: .init(x: 2, y: 27), size: CGSize(width: 98, height: 25)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 4, section: 0))?.frame, CGRect(origin: .init(x: 100, y: 27), size: CGSize(width: 49, height: 25)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 5, section: 0))?.frame, CGRect(origin: .init(x: 149, y: 27), size: CGSize(width: 49, height: 25)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 6, section: 0))?.frame, CGRect(origin: .init(x: 100, y: 52), size: CGSize(width: 98, height: 25)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 7, section: 0))?.frame, CGRect(origin: .init(x: 2, y: 52), size: CGSize(width: 98, height: 12)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 8, section: 0))?.frame, CGRect(origin: .init(x: 2, y: 64), size: CGSize(width: 98, height: 12)))

    XCTAssertEqual(layout.cachedItemAttributesBySection[1].count, 10)
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))?.frame, CGRect(origin: .init(x: 2, y: 106), size: CGSize(width: 93, height: 15)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 1, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 106), size: CGSize(width: 41.5, height: 15)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 2, section: 1))?.frame, CGRect(origin: .init(x: 156.5, y: 106), size: CGSize(width: 41.5, height: 15)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 3, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 131), size: CGSize(width: 93, height: 15)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 4, section: 1))?.frame, CGRect(origin: .init(x: 2, y: 131), size: CGSize(width: 93, height: 2)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 5, section: 1))?.frame, CGRect(origin: .init(x: 2, y: 143), size: CGSize(width: 93, height: 2)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 6, section: 1))?.frame, CGRect(origin: .init(x: 2, y: 156), size: CGSize(width: 93, height: 15)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 7, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 156), size: CGSize(width: 93, height: 2)))
    XCTAssertEqual(layout.layoutAttributesForItem(at: IndexPath(item: 8, section: 1))?.frame, CGRect(origin: .init(x: 105, y: 168), size: CGSize(width: 93, height: 2)))

    XCTAssertEqual(layout.collectionViewContentSize, CGSize(width: 200, height: 198))
    XCTAssertEqual(layout.contentSize, layout.collectionViewContentSize)
  }
}

extension VerticalMosaicBlueprintLayoutDelegateTests: CollectionViewFlowLayoutDelegate {

  func collectionView(_ collectionView: CollectionView, layout collectionViewLayout: CollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    let minimumInteritemSpacing: CGFloat = section % 2 == 1 ? 10 : 0
    return minimumInteritemSpacing
  }

  func collectionView(_ collectionView: CollectionView, layout collectionViewLayout: CollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    let minimumLineSpacing: CGFloat = section % 2 == 1 ? 10 : 0
    return minimumLineSpacing
  }
}
