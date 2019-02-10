#if os(macOS)
import Cocoa
#else
import UIKit
#endif

class BlueprintInvalidationContext: FlowLayoutInvalidationContext {
  var shouldInvalidateEverything = true

  var headerIndexPaths = [IndexPath]()
  var footerIndexPaths = [IndexPath]()

  #if os(macOS)
  override var invalidatedSupplementaryIndexPaths: [CollectionViewElementKind : Set<IndexPath>]? {
    return !headerIndexPaths.isEmpty ? [
      CollectionView.collectionViewHeaderType: Set(headerIndexPaths),
      CollectionView.collectionViewFooterType: Set(footerIndexPaths)
      ] : nil
  }
  #else
  override var invalidatedSupplementaryIndexPaths: [String : [IndexPath]]? {
    return !headerIndexPaths.isEmpty ? [
      CollectionView.collectionViewHeaderType: headerIndexPaths,
      CollectionView.collectionViewFooterType: footerIndexPaths
      ] : nil
  }
  #endif

  override var invalidateEverything: Bool {
    return shouldInvalidateEverything
  }
}
