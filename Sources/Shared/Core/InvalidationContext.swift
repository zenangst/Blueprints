#if os(macOS)
import Cocoa
#else
import UIKit
#endif

class InvalidationContext: FlowLayoutInvalidationContext {
  var shouldInvalidateEverything = true
  override var invalidateEverything: Bool {
    return shouldInvalidateEverything
  }
}
