#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

open class DefaultAnimator: CollectionViewFlowLayoutAnimator {
  public var animation: FlowLayoutAnimation?
  public var indexPathsToAnimate: [IndexPath] = []
  public var indexPathsToMove: [IndexPath] = []

  weak public var collectionViewFlowLayout: CollectionViewFlowLayout?

  public init() {}
}
