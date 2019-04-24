#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

@objc public protocol BlueprintLayoutAnimator: class {
  var animation: BlueprintLayoutAnimation { get set }
  var indexPathsToAnimate: Set<IndexPath> { get set }
  var indexPathsToMove: Set<IndexPath> { get set }
  var collectionViewFlowLayout: CollectionViewFlowLayout? { get set }

  func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath, with attributes: LayoutAttributes) -> LayoutAttributes?
  func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath, with attributes: LayoutAttributes) -> LayoutAttributes?
  func prepare(forCollectionViewUpdates updateItems: [CollectionViewUpdateItem])
}
