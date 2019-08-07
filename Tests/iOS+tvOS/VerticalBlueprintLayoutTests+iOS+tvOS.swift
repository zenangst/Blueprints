import XCTest
import Blueprints

class VerticalBlueprintLayoutTests_iOS_tvOS: XCTestCase {
  let dataSource = MockDataSource()
  var collectionView: CollectionView!
  var verticalLayout: VerticalBlueprintLayout!

  override func setUp() {
    super.setUp()
    let (collectionView, layout) = Helper.createVerticalLayout(dataSource: dataSource)
    self.collectionView = collectionView
    self.verticalLayout = layout
  }

  func testLayoutAttributesForElements() {
    verticalLayout.minimumLineSpacing = 0
    verticalLayout.minimumInteritemSpacing = 0
    verticalLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    verticalLayout.prepare()

    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: .zero)?.count, 4)

    let size = CGSize(width: 50, height: 50)
    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 0, y: 0), size: size))?.count, 8)
    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 0, y: 25), size: size))?.count, 8)
    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 0, y: 50), size: size))?.count, 10)
    XCTAssertEqual(verticalLayout.layoutAttributesForElements(in: CGRect(origin: .init(x: 0, y: 0), size: CGSize(width: 500, height: 500)))?.count, 10)
  }
}
