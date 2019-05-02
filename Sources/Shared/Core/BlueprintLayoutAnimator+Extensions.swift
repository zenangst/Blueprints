#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

extension BlueprintLayoutAnimator {
  public func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath, with attributes: LayoutAttributes) -> LayoutAttributes? {
    guard indexPathsToAnimate.contains(itemIndexPath) else {
        if let index = indexPathsToMove.firstIndex(of: itemIndexPath) {
        indexPathsToMove.remove(at: index)
        return attributes
      }
      return nil
    }

    if let index = indexPathsToAnimate.firstIndex(of: itemIndexPath) {
      indexPathsToAnimate.remove(at: index)
    }

    guard animation != .none else {
      return nil
    }

    applyAnimation(animation, type: .insert, to: attributes)

    return attributes
  }

  public func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath, with attributes: LayoutAttributes) -> LayoutAttributes? {
    guard indexPathsToAnimate.contains(itemIndexPath) else {
        if let index = indexPathsToMove.firstIndex(of: itemIndexPath) {
        indexPathsToMove.remove(at: index)
        return attributes
      }
      return nil
    }

    if let index = indexPathsToAnimate.firstIndex(of: itemIndexPath) {
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
        indexPathsToMove.insert(updateItem.indexPathBeforeUpdate!)
        indexPathsToMove.insert(updateItem.indexPathAfterUpdate!)
      default:
        currentIndexPath = nil
      }

      if let indexPath = currentIndexPath {
        indexPathsToAnimate.insert(indexPath)
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

    let excludedAnimationTypes: [BlueprintLayoutAnimation] = [.top, .bottom, .none]

    if !excludedAnimationTypes.contains(animation) {
      applyAnimationFix(type, collectionViewFlowLayout: collectionViewFlowLayout, attributes)
    }

    switch type {
    case .insert:
      switch animation {
      case .fade:
        attributes.frame.origin.x += 0.5
        return
      case .right:
        attributes.frame.origin.x = collectionView.bounds.minX
      case .left:
        attributes.frame.origin.x = collectionView.bounds.maxX
      case .top:
        attributes.frame.origin.y -= attributes.frame.size.height
      case .bottom:
        if attributes.frame.origin.x == collectionViewFlowLayout.sectionInset.left {
          attributes.frame.origin = .init(x: attributes.frame.origin.x,
                                          y: collectionView.bounds.maxY)
        } else {
          attributes.frame.origin.y += collectionView.bounds.maxY
        }
      case .none:
        attributes.alpha = 1.0
        return
      case .middle:
        attributes.size = .zero
        attributes.frame.origin = .init(x: attributes.frame.origin.x,
                                        y: attributes.frame.origin.y * 2)
      case .automatic:
        if count == 1 {
          attributes.alpha = 0.0
          return
        }
        attributes.frame.origin = .init(x: attributes.frame.origin.x,
                                        y: attributes.frame.origin.y - attributes.frame.size.height)
        attributes.isHidden = false
        attributes.alpha = 1.0
        return
      }

      attributes.frame.origin.x = 0.5
      attributes.isHidden = false
      attributes.alpha = 1.0
    case .delete:
      switch animation {
      case .fade:
        //        attributes.frame.size = .zero
        break
      case .right:
        attributes.frame.origin.x = collectionView.bounds.maxX
      case .left:
        attributes.frame.origin.x = collectionView.bounds.minX
      case .top:
        attributes.frame.origin.y -= attributes.frame.size.height
      case .bottom:
        if attributes.frame.origin.x == collectionViewFlowLayout.sectionInset.left {
          attributes.frame.origin = .init(x: attributes.frame.origin.x,
                                          y: collectionView.bounds.maxY)
        } else {
          attributes.frame.origin.y += collectionView.bounds.maxY
        }
      case .none:
        attributes.alpha = 1.0
        return
      case .middle:
        attributes.frame.origin = .init(x: attributes.frame.origin.x,
                                        y: attributes.frame.size.height / 2)
      case .automatic:
        if count == 0 {
          attributes.alpha = 0.0
          return
        }
        attributes.frame.origin = .init(x: attributes.frame.origin.x,
                                        y: attributes.frame.origin.y - attributes.frame.size.height)
        attributes.isHidden = true
        attributes.alpha = 0.0
        return
      }

      attributes.isHidden = true
      attributes.alpha = 0.0
    case .move:
      break
    }
  }
}
