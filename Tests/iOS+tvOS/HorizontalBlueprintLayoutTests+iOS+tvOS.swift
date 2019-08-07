import XCTest
import Blueprints

class HorizontalBlueprintLayoutTests_iOS_tvOS: XCTestCase {
  let dataSource = MockDataSource()
  var collectionView: CollectionView!
  var horizontalLayout: HorizontalBlueprintLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createHorizontalLayout(dataSource: dataSource)
    self.collectionView = collectionView
    self.horizontalLayout = layout
  }

  func testLayoutAttributesForElements() {
    horizontalLayout.minimumLineSpacing = 0
    horizontalLayout.minimumInteritemSpacing = 0
    horizontalLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    horizontalLayout.prepare()

    let size: CGSize = .init(width: 50, height: 50)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 0, y: 0), size: size))?.count, 2)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 75, y: 0), size: size))?.count, 2)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 100, y: 0), size: size))?.count, 3)
    XCTAssertEqual(horizontalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 0, y: 0), size: .init(width: 500, height: 500)))?.count, 10)
  }
}
