#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

@objc open class DefaultLayoutAnimator: NSObject, BlueprintLayoutAnimator {
  public var animation: BlueprintLayoutAnimation
  public var indexPathsToAnimate: [IndexPath] = []
  public var indexPathsToMove: [IndexPath] = []

  weak public var collectionViewFlowLayout: CollectionViewFlowLayout?

  @objc public init(animation: BlueprintLayoutAnimation = .automatic) {
    self.animation = animation
    super.init()
  }

  @objc open func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath, with attributes: LayoutAttributes) -> LayoutAttributes? {
    guard indexPathsToAnimate.contains(itemIndexPath) else {
      if let index = indexPathsToMove.index(of: itemIndexPath) {
        indexPathsToMove.remove(at: index)
        attributes.alpha = 1.0
        return attributes
      }
      return nil
    }

    if let index = indexPathsToAnimate.index(of: itemIndexPath) {
      indexPathsToAnimate.remove(at: index)
    }

    guard animation != .none else {
      return nil
    }

    applyAnimation(animation, type: .insert, to: attributes)

    return attributes
  }

  @objc open func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath, with attributes: LayoutAttributes) -> LayoutAttributes? {
    guard indexPathsToAnimate.contains(itemIndexPath) else {
      if let index = indexPathsToMove.index(of: itemIndexPath) {
        indexPathsToMove.remove(at: index)
        attributes.alpha = 1.0
        return attributes
      }
      return nil
    }

    if let index = indexPathsToAnimate.index(of: itemIndexPath) {
      indexPathsToAnimate.remove(at: index)
    }

    guard animation != .none else {
      return nil
    }

    applyAnimation(animation, type: .delete, to: attributes)

    return attributes
  }

  public func prepare(forCollectionViewUpdates updateItems: [CollectionViewUpdateItem]) {
    var currentIndexPath: IndexPath?
    for updateItem in updateItems {
      switch updateItem.updateAction {
      case .insert:
        currentIndexPath = updateItem.indexPathAfterUpdate
      case .delete:
        currentIndexPath = updateItem.indexPathBeforeUpdate
      case .move:
        currentIndexPath = nil
        indexPathsToMove.append(updateItem.indexPathBeforeUpdate!)
        indexPathsToMove.append(updateItem.indexPathAfterUpdate!)
      default:
        currentIndexPath = nil
      }

      if let indexPath = currentIndexPath {
        indexPathsToAnimate.append(indexPath)
      }
    }
  }

  private func applyAnimation(_ animation: BlueprintLayoutAnimation,
                              type: BlueprintLayoutAnimationType,
                              to attributes: LayoutAttributes) {
    guard let collectionViewFlowLayout = collectionViewFlowLayout,
      let collectionView = collectionViewFlowLayout.collectionView,
      let dataSource = collectionView.dataSource
      else
    {
      return
    }

    let count = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)

    if type == .move {
      return
    }

    let excludedAnimationTypes: [BlueprintLayoutAnimation] = [.top, .bottom]

    if !excludedAnimationTypes.contains(animation) {
      applyAnimationFix(type, collectionViewFlowLayout: collectionViewFlowLayout, attributes)
    }

    switch animation {
    case .fade:
      attributes.alpha = 0.0
    case .right:
      attributes.frame.origin.x = type == .insert ? collectionView.bounds.minX : collectionView.bounds.maxX
    case .left:
      attributes.frame.origin.x = type == .insert ? collectionView.bounds.maxX : collectionView.bounds.minX
    case .top:
      attributes.frame.origin.y -= attributes.frame.size.height
    case .bottom:
      if attributes.frame.origin.x == collectionViewFlowLayout.sectionInset.left {
        attributes.frame.origin = .init(x: attributes.frame.origin.x,
                                        y: attributes.frame.origin.y + attributes.frame.size.height)
      } else {
        attributes.frame.origin.y += attributes.frame.size.height
      }
    case .none:
      attributes.alpha = 1.0
    case .middle:
      switch type {
      case .insert:
        attributes.size = .zero
        attributes.frame.origin = .init(x: attributes.frame.origin.x,
                                        y: attributes.frame.origin.y * 2)
      case .delete:
        attributes.frame.origin = .init(x: attributes.frame.origin.x,
                                        y: attributes.frame.size.height / 2)
        return
      default:
        break
      }
    case .automatic:
      switch type {
      case .insert:
        if count == 1 {
          attributes.alpha = 0.0
          return
        }
      case .delete:
        if count == 0 {
          attributes.alpha = 0.0
          return
        }
      default:
        break
      }

      attributes.zIndex = -1
      attributes.alpha = 1.0
      attributes.frame.origin = .init(x: attributes.frame.origin.x,
                                      y: attributes.frame.origin.x - attributes.frame.size.height)
    }
  }
}
