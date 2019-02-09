#if os(macOS)
import Cocoa
#else
import UIKit
#endif

class InvalidationContext: FlowLayoutInvalidationContext {
  var invalidateSectionHeadersFooters = [IndexPath]()
  var shouldInvalidateEverything = true

  override var invalidatedItemIndexPaths: Set<IndexPath>? {
    return !invalidateSectionHeadersFooters.isEmpty ? Set(invalidateSectionHeadersFooters) : nil
  }

  override var invalidateEverything: Bool {
    return shouldInvalidateEverything
  }
}
