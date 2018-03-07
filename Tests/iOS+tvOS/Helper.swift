import Blueprint
import UIKit

class Helper {
  static func createHorizontalLayout(dataSource: UICollectionViewDataSource) -> (collectionView: CollectionView, layout: HorizontalBlueprintLayout) {
    let frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
    let layout = HorizontalBlueprintLayout(
      minimumInteritemSpacing: 10,
      minimumLineSpacing: 10,
      sectionInset: EdgeInsets(top: 10, left: 50, bottom: 10, right: 50))
    layout.itemSize = CGSize(width: 50, height: 50)
    layout.estimatedItemSize = CGSize(width: 50, height: 50)
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.dataSource = dataSource

    return (collectionView: collectionView, layout: layout)
  }

  static func createVerticalLayout(dataSource: UICollectionViewDataSource) -> (collectionView: CollectionView, layout: VerticalBlueprintLayout) {
    let frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))

    let layout = VerticalBlueprintLayout(
      minimumInteritemSpacing: 10,
      minimumLineSpacing: 10,
      sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    layout.itemSize = CGSize(width: 50, height: 50)
    layout.estimatedItemSize = CGSize(width: 50, height: 50)
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.dataSource = dataSource

    return (collectionView: collectionView, layout: layout)
  }

  static func createAnimator(dataSource: UICollectionViewDataSource) -> DefaultAnimator {
    let frame = CGRect(origin: .zero, size: .init(width: 200, height: 200))
    let animator = DefaultAnimator()
    let layout = CoreBlueprintLayout(animator: animator)
    animator.CollectionViewFlowLayout = layout
    let collectionView = CollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.dataSource = dataSource
    layout.prepare()

    return animator
  }
}
