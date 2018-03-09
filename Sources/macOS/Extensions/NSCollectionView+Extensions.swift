import Cocoa

public extension NSCollectionView {
  static var collectionViewHeaderType: NSCollectionView.SupplementaryElementKind { return .sectionHeader }
  static var collectionViewFooterType: NSCollectionView.SupplementaryElementKind { return .sectionFooter }

  convenience public init(frame: CGRect, collectionViewLayout: CollectionViewFlowLayout) {
    self.init(frame: frame)
    self.collectionViewLayout = collectionViewLayout
  }
}
