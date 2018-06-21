import XCTest
import Blueprints

class PerformanceTests: XCTestCase {
  struct Model {}

  class DataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      return cell
    }

    var models = [Model]()

    init(amount: Int) {
      super.init()

      var models = [Model]()
      for _ in 0..<amount { models.append(Model()) }
      self.models = models
    }
  }

  class LegacyVerticalBlueprintLayout: VerticalBlueprintLayout {
    override open func layoutAttributesForElements(in rect: CGRect) -> LayoutAttributesForElements {
      return allCachedAttributes.filter { $0.frame.intersects(rect) }
    }
  }

  class LegacyHorizontalBlueprintLayout: HorizontalBlueprintLayout {
    override open func layoutAttributesForElements(in rect: CGRect) -> LayoutAttributesForElements {
      return allCachedAttributes.filter { $0.frame.intersects(rect) }
    }
  }

  func testPerformanceLegacyVerticalLayoutPerformance() {
    let dataSource = DataSource(amount: 1_000_000)
    var layout: BlueprintLayout = LegacyVerticalBlueprintLayout(itemsPerRow: 1,
                                                                itemSize: CGSize(width: 200, height: 60),
                                                                minimumInteritemSpacing: 10,
                                                                minimumLineSpacing: 10,
                                                                sectionInset: .zero)
    let frame = CGRect(origin: .zero, size: .init(width: 200, height: 200))
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.dataSource = dataSource
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    let startTime = CFAbsoluteTimeGetCurrent()
    layout.prepare()

    let rect = CGRect(origin: .init(x: 0, y: -200), size: .init(width: 200, height: 400))
    var attributes = layout.layoutAttributesForElements(in: rect)!

    XCTAssertEqual(attributes.count, 3)
    let legacyBenchmark = CFAbsoluteTimeGetCurrent() - startTime
    Swift.print("🦀: \(legacyBenchmark)")

  }
  func testPerformanceExistingVerticalLayoutPerformance() {
    let dataSource = DataSource(amount: 1_000_000)
    let layout = VerticalBlueprintLayout(itemsPerRow: 1,
                                     itemSize: CGSize(width: 200, height: 60),
                                     minimumInteritemSpacing: 10,
                                     minimumLineSpacing: 10,
                                     sectionInset: .zero)
    let frame = CGRect(origin: .zero, size: .init(width: 200, height: 200))
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    let rect = CGRect(origin: .init(x: 0, y: -200), size: .init(width: 200, height: 400))
    collectionView.dataSource = dataSource
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    layout.newAlgorithm = false
    collectionView.collectionViewLayout = layout
    layout.prepare()
    let startTime = CFAbsoluteTimeGetCurrent()
    let attributes = layout.layoutAttributesForElements(in: rect)!
    XCTAssertEqual(attributes.count, 3)
    let binarySearchBenchmark = CFAbsoluteTimeGetCurrent() - startTime
    Swift.print("🚗: \(binarySearchBenchmark)")

  }
  func testPerformanceNewVerticalLayoutPerformance() {
    let dataSource = DataSource(amount: 1_000_000)
    let layout = VerticalBlueprintLayout(itemsPerRow: 1,
                                     itemSize: CGSize(width: 200, height: 60),
                                     minimumInteritemSpacing: 10,
                                     minimumLineSpacing: 10,
                                     sectionInset: .zero)
    let frame = CGRect(origin: .zero, size: .init(width: 200, height: 200))
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    let rect = CGRect(origin: .init(x: 0, y: -200), size: .init(width: 200, height: 400))
    collectionView.dataSource = dataSource
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    layout.newAlgorithm = true
    collectionView.collectionViewLayout = layout
    layout.prepare()
    let startTime = CFAbsoluteTimeGetCurrent()
    let attributes = layout.layoutAttributesForElements(in: rect)!
    XCTAssertEqual(attributes.count, 3)
    let binarySearchBenchmark = CFAbsoluteTimeGetCurrent() - startTime
    Swift.print("🏎: \(binarySearchBenchmark)")
  }

  func testPerformanceBetweenLegacyAndNewBinarySearchOnHorizontalLayout() {
    let dataSource = DataSource(amount: 50_000)
    var layout: BlueprintLayout = LegacyHorizontalBlueprintLayout(itemsPerRow: 3,
                                                                  itemSize: CGSize(width: 200, height: 60),
                                                                  minimumInteritemSpacing: 10,
                                                                  minimumLineSpacing: 10,
                                                                  sectionInset: .zero)
    let frame = CGRect(origin: .zero, size: .init(width: 200, height: 200))
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.dataSource = dataSource
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    layout.prepare()

    let rect = CGRect(origin: .init(x: 0, y: -200), size: .init(width: 200, height: 400))
    var startTime = CFAbsoluteTimeGetCurrent()
    var attributes = layout.layoutAttributesForElements(in: rect)!

    XCTAssertEqual(attributes.count, 3)
    let legacyBenchmark = CFAbsoluteTimeGetCurrent() - startTime
    Swift.print("🦀: \(legacyBenchmark)")

    layout = HorizontalBlueprintLayout(itemsPerRow: 3,
                                       itemSize: CGSize(width: 200, height: 60),
                                       minimumInteritemSpacing: 10,
                                       minimumLineSpacing: 10,
                                       sectionInset: .zero)
    collectionView.collectionViewLayout = layout
    layout.prepare()
    startTime = CFAbsoluteTimeGetCurrent()

    attributes = layout.layoutAttributesForElements(in: rect)!
    XCTAssertEqual(attributes.count, 3)
    let binarySearchBenchmark = CFAbsoluteTimeGetCurrent() - startTime

    Swift.print("💪: \(binarySearchBenchmark)")
    XCTAssertTrue(binarySearchBenchmark < legacyBenchmark)
  }
}
