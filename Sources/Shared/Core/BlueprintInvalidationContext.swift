#if os(macOS)
import Cocoa
#else
import UIKit
#endif

open class BlueprintInvalidationContext: FlowLayoutInvalidationContext {
  open var shouldInvalidateEverything: Bool = true
  open var headerIndexPaths: [IndexPath] = [IndexPath]()
  open var footerIndexPaths: [IndexPath] = [IndexPath]()
  open var invalidatePreferredLayoutAttributes: Bool = false

  #if os(macOS)
  override open var invalidatedSupplementaryIndexPaths: [CollectionViewElementKind : Set<IndexPath>]? {
    return !headerIndexPaths.isEmpty ? [
      CollectionView.collectionViewHeaderType: Set(headerIndexPaths),
      CollectionView.collectionViewFooterType: Set(footerIndexPaths)
      ] : nil
  }
  #else
  override open var invalidatedSupplementaryIndexPaths: [String : [IndexPath]]? {
    return !headerIndexPaths.isEmpty ? [
      CollectionView.collectionViewHeaderType: headerIndexPaths,
      CollectionView.collectionViewFooterType: footerIndexPaths
      ] : nil
  }
  #endif

  override open var invalidateEverything: Bool {
    return shouldInvalidateEverything
  }
}
