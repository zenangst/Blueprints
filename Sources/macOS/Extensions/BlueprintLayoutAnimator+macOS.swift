import Cocoa

extension BlueprintLayoutAnimator {
  func applyAnimationFix(_ type: BlueprintLayoutAnimationType, collectionViewFlowLayout: CollectionViewFlowLayout, _ attributes: LayoutAttributes) {
    // Add y offset to the first item in the row, otherwise it won't animate.
    if type == .insert && attributes.frame.origin.x == collectionViewFlowLayout.sectionInset.left {
      // To make it more accurate we can use a smaller offset for items that are not the
      // first item in the first row.
      let offset: CGFloat = attributes.indexPath!.item > 0 ? 0.1 : collectionViewFlowLayout.sectionInset.left
      attributes.frame.origin = .init(x: attributes.frame.origin.x, y: attributes.frame.origin.y - offset)
    }
  }
}
