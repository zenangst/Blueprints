import UIKit

extension UICollectionView {
  static var collectionViewHeaderType: String { return UICollectionElementKindSectionHeader }
  static var collectionViewFooterType: String { return UICollectionElementKindSectionFooter }

  var documentRect: CGRect {
    return frame
  }

  var visibleIndexPaths: [IndexPath] {
    return indexPathsForVisibleItems
  }
}
