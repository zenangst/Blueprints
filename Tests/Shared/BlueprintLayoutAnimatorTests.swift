import XCTest
import Blueprints

class BlueprintLayoutAnimatorTests: XCTestCase {
  class MockCollectionViewUpdateItem: CollectionViewUpdateItem {
    var beforeIndexPath: IndexPath?
    var afterIndexPath: IndexPath?
    var action: CollectionViewUpdateAction = .none

    init(action: CollectionViewUpdateAction? = nil, beforeIndexPath: IndexPath? = nil, afterIndexPath: IndexPath? = nil) {
      self.beforeIndexPath = beforeIndexPath
      self.afterIndexPath = afterIndexPath
      super.init()

      switch (beforeIndexPath != nil, afterIndexPath != nil) {
      case (true, true):
        self.action = .move
      case (false, true):
        self.action = .insert
      case (true, false):
        self.action = .delete
      default:
        self.action = .none
      }

      if let action = action {
        self.action = action
      }
    }

    override var indexPathBeforeUpdate: IndexPath? { return beforeIndexPath }
    override var indexPathAfterUpdate: IndexPath? { return afterIndexPath }
    override var updateAction: UICollectionViewUpdateItem.Action { return action }
  }

  let dataSource = MockDataSource(numberOfItems: 15)

  func testDefaultAnimatorFadeInsertion() {
    let (animator, collectionView, layout) = Helper.createAnimator(dataSource: dataSource)
    let indexPath = IndexPath(item: 0, section: 0)
    let insertion = MockCollectionViewUpdateItem(afterIndexPath: indexPath)

    animator.prepare(forCollectionViewUpdates: [insertion])
    XCTAssertTrue(animator.indexPathsToAnimate.contains(indexPath))

    let attributes = LayoutAttributes()
    attributes.size = .init(width: 100, height: 100)

    XCTAssertEqual(attributes.alpha, 1.0)

    animator.animation = .fade
    _ = animator.initialLayoutAttributesForAppearingItem(at: indexPath, with: attributes)
    XCTAssertEqual(attributes.alpha, 0.0)
  }

  func testDefaultAnimatorFadeDeletion() {
    let (animator, collectionView, layout) = Helper.createAnimator(dataSource: dataSource)
    let indexPath = IndexPath(item: 0, section: 0)
    let deletion = MockCollectionViewUpdateItem(beforeIndexPath: indexPath)

    animator.prepare(forCollectionViewUpdates: [deletion])
    XCTAssertTrue(animator.indexPathsToAnimate.contains(indexPath))

    let attributes = LayoutAttributes()
    attributes.size = .init(width: 100, height: 100)

    XCTAssertEqual(attributes.alpha, 1.0)

    animator.animation = .fade
    _ = animator.finalLayoutAttributesForDisappearingItem(at: indexPath, with: attributes)
    XCTAssertEqual(attributes.alpha, 0.0)
  }

  func testDefaultAnimatorFadeMultipleAttributes() {
    let (animator, collectionView, layout) = Helper.createAnimator(dataSource: dataSource)
    let beforeIndexPath = IndexPath(item: 0, section: 0)
    let afterIndexPath = IndexPath(item: 1, section: 0)
    let move = MockCollectionViewUpdateItem(
      beforeIndexPath: beforeIndexPath,
      afterIndexPath: afterIndexPath
    )

    animator.prepare(forCollectionViewUpdates: [move])
    XCTAssertTrue(animator.indexPathsToMove.contains(beforeIndexPath))

    let attributes = LayoutAttributes()
    attributes.size = .init(width: 100, height: 100)
    attributes.alpha = 0.0
    animator.animation = .fade
    _ = animator.initialLayoutAttributesForAppearingItem(at: beforeIndexPath, with: attributes)
    XCTAssertEqual(attributes.alpha, 1.0)
  }
}
