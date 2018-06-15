#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

public enum BlueprintSupplementaryKind {
  case header, footer

  var collectionViewSupplementaryType: CollectionViewElementKind {
    switch self {
    case .header:
      return CollectionView.collectionViewHeaderType
    case .footer:
      return CollectionView.collectionViewFooterType
    }
  }
}
