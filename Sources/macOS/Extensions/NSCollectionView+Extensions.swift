import Cocoa

public extension CollectionView {
  public static var collectionViewHeaderType: NSCollectionView.SupplementaryElementKind { return NSCollectionView.elementKindSectionHeader }
  public static var collectionViewFooterType: NSCollectionView.SupplementaryElementKind { return NSCollectionView.elementKindSectionFooter }

  public var contentOffset: CGPoint {
    get { return enclosingScrollView?.documentVisibleRect.origin ?? .zero }
    set { scroll(newValue) }
  }

  var visibleIndexPaths: Set<IndexPath> {
    return indexPathsForVisibleItems()
  }

  // TEMP Comment - Remove - Required to resolve #79
  var documentRect: CGRect {
    guard let enclosingScrollView = enclosingScrollView else {
      return .zero
    }
    if frame.width > enclosingScrollView.frame.width {
      return enclosingScrollView.frame
    }
    return frame
  }

  convenience public init(frame: CGRect, collectionViewLayout: CollectionViewFlowLayout) {
    self.init(frame: frame)
    self.collectionViewLayout = collectionViewLayout
  }
}
