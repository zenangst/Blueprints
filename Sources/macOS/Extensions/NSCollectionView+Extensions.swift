import Cocoa

public extension NSCollectionView {
  convenience public init(frame: CGRect, collectionViewLayout: CollectionViewFlowLayout) {
    self.init(frame: frame)
    self.collectionViewLayout = collectionViewLayout
  }
}
