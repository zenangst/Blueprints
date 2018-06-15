#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

open class DefaultLayoutAnimator: BlueprintLayoutAnimator {
  public var animation: BlueprintLayoutAnimation?
  public var indexPathsToAnimate: [IndexPath] = []
  public var indexPathsToMove: [IndexPath] = []

  weak public var CollectionViewFlowLayout: CollectionViewFlowLayout?

  public init() {}
}
