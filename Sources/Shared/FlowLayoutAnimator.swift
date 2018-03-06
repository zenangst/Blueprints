#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

public protocol CollectionViewFlowLayoutAnimator: class {
  var animation: FlowLayoutAnimation? { get set }
  var indexPathsToAnimate: [IndexPath] { get set }
  var indexPathsToMove: [IndexPath] { get set }
  var collectionViewFlowLayout: CollectionViewFlowLayout? { get set }

  func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath, with attributes: LayoutAttributes) -> LayoutAttributes?
  func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath, with attributes: LayoutAttributes) -> LayoutAttributes?
  func prepare(forCollectionViewUpdates updateItems: [CollectionViewUpdateItem])
}
