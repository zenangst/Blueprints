import Blueprints
import UIKit

class MockDelegate: NSObject, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = indexPath.item % 2 == 1 ? 200 : 275
    return CGSize(width: 200, height: height)
  }
}

class Helper {
  static func createHorizontalLayout(dataSource: UICollectionViewDataSource,
                                     withItemsPerRow: CGFloat = 0.0) -> (collectionView: CollectionView, layout: HorizontalBlueprintLayout) {
    let frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
    let layout: HorizontalBlueprintLayout

    if withItemsPerRow > 0.0 {
      layout = HorizontalBlueprintLayout(
        itemsPerRow: withItemsPerRow,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: EdgeInsets(top: 10, left: 50, bottom: 10, right: 50))
    } else {
      layout = HorizontalBlueprintLayout(
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: EdgeInsets(top: 10, left: 50, bottom: 10, right: 50))
    }

    layout.itemSize = CGSize(width: 50, height: 50)
    layout.estimatedItemSize = .zero
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.dataSource = dataSource

    return (collectionView: collectionView, layout: layout)
  }

  static func createVerticalLayout(dataSource: UICollectionViewDataSource, withItemsPerRow: CGFloat = 0.0) -> (collectionView: CollectionView, layout: VerticalBlueprintLayout) {
    let frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
    let layout: VerticalBlueprintLayout

    if withItemsPerRow > 0.0 {
      layout = VerticalBlueprintLayout(
        itemsPerRow: withItemsPerRow,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    } else {
      layout = VerticalBlueprintLayout(
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    layout.itemSize = CGSize(width: 50, height: 50)
    layout.estimatedItemSize = .zero
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.dataSource = dataSource

    return (collectionView: collectionView, layout: layout)
  }

  static func createAnimator(dataSource: UICollectionViewDataSource) -> (DefaultLayoutAnimator, CollectionView, CollectionViewFlowLayout) {
    let frame = CGRect(origin: .zero, size: .init(width: 200, height: 200))
    let animator = DefaultLayoutAnimator()
    let layout = BlueprintLayout(animator: animator)
    animator.collectionViewFlowLayout = layout
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.dataSource = dataSource
    layout.prepare()

    return (animator, collectionView, layout)
  }

  static func createVerticalMosaicLayout(dataSource: UICollectionViewDataSource) -> (collectionView: CollectionView, layout: VerticalMosaicBlueprintLayout) {
    let frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
    let patterns = [
      MosaicPattern(alignment: .left, direction: .vertical, amount: 2, multiplier: 0.5),
      MosaicPattern(alignment: .left, direction: .horizontal, amount: 2, multiplier: 0.5),
      MosaicPattern(alignment: .right, direction: .vertical, amount: 2, multiplier: 0.5)
    ]

    let layout = VerticalMosaicBlueprintLayout(
      minimumInteritemSpacing: 2,
      minimumLineSpacing: 2,
      sectionInset: EdgeInsets(top: 2, left: 2, bottom: 2, right: 2),
      patterns: patterns)
    layout.itemSize = CGSize(width: 50, height: 50)
    layout.estimatedItemSize = CGSize(width: 50, height: 50)
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.dataSource = dataSource

    return (collectionView: collectionView, layout: layout)
  }
}

class DynamicSizeVerticalCell: UICollectionViewCell {
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    let attributes = layoutAttributes
    attributes.frame.size = CGSize(width: 100, height: 100)
    return attributes
  }
}

class DynamicSizeHorizontalCell: UICollectionViewCell {
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    let attributes = layoutAttributes
    attributes.frame.size = CGSize(width: 100, height: 100)
    return attributes
  }
}

class DynamicSizeDataSource: NSObject, UICollectionViewDataSource {
  var numberOfItems: Int = 10

  convenience init(numberOfItems: Int = 10) {
    self.init()
    self.numberOfItems = numberOfItems
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfItems
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamic", for: indexPath)
    return cell
  }
}
