import Cocoa

public extension CollectionView {
  static var collectionViewHeaderType: NSCollectionView.SupplementaryElementKind { return NSCollectionView.elementKindSectionHeader }
  static var collectionViewFooterType: NSCollectionView.SupplementaryElementKind { return NSCollectionView.elementKindSectionFooter }

  var contentOffset: CGPoint {
    get { return enclosingScrollView?.documentVisibleRect.origin ?? .zero }
    set { scroll(newValue) }
  }

  var visibleIndexPaths: Set<IndexPath> {
    return indexPathsForVisibleItems()
  }

  var documentRect: CGRect {
    guard let enclosingScrollView = enclosingScrollView else {
      return .zero
    }
    if frame.width > enclosingScrollView.frame.width {
      return enclosingScrollView.frame
    }
    return frame
  }

  convenience init(frame: CGRect, collectionViewLayout: CollectionViewFlowLayout) {
    self.init(frame: frame)
    self.collectionViewLayout = collectionViewLayout
  }
}
