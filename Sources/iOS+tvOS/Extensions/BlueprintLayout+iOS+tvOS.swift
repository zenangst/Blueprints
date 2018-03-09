import UIKit

extension BlueprintLayout {
  func createHeader(_ indexPath: IndexPath, atX x: CGFloat = 0, atY y: CGFloat = 0) -> LayoutAttributes {
    let layoutAttribute = LayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
    layoutAttribute.zIndex = indexPath.section
    layoutAttribute.size.height = headerReferenceSize.height
    layoutAttribute.frame.origin.x = x
    layoutAttribute.frame.origin.y = y

    return layoutAttribute
  }

  func createFooter(_ indexPath: IndexPath, atX x: CGFloat = 0, atY y: CGFloat = 0) -> LayoutAttributes {
    let layoutAttribute = LayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
    layoutAttribute.zIndex = indexPath.section
    layoutAttribute.size.height = footerReferenceSize.height
    layoutAttribute.frame.origin.x = x
    layoutAttribute.frame.origin.y = y + sectionInset.bottom

    return layoutAttribute
  }
}
