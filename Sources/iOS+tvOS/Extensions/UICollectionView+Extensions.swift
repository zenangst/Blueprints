import UIKit

extension UICollectionView {
  static var collectionViewHeaderType: String { return UICollectionView.elementKindSectionHeader }
  static var collectionViewFooterType: String { return UICollectionView.elementKindSectionFooter }

  var documentRect: CGRect {
    return frame
  }

  var visibleIndexPaths: [IndexPath] {
    return indexPathsForVisibleItems
  }
}
