import Cocoa

extension BlueprintLayout {
  func createHeader(_ indexPath: IndexPath, atX x: CGFloat = 0, atY y: CGFloat = 0) -> LayoutAttributes {
    let layoutAttribute = LayoutAttributes.init(forSupplementaryViewOfKind: .sectionHeader, with: indexPath)
    layoutAttribute.zIndex = indexPath.section
    layoutAttribute.size.height = headerReferenceSize.height
    layoutAttribute.frame.origin.x = x
    layoutAttribute.frame.origin.y = y

    return layoutAttribute
  }

  func createFooter(_ indexPath: IndexPath, atX x: CGFloat = 0, atY y: CGFloat = 0) -> LayoutAttributes {
    let layoutAttribute = LayoutAttributes.init(forSupplementaryViewOfKind: .sectionFooter, with: indexPath)
    layoutAttribute.zIndex = indexPath.section
    layoutAttribute.size.height = footerReferenceSize.height
    layoutAttribute.frame.origin.x = x
    layoutAttribute.frame.origin.y = y + sectionInset.bottom

    return layoutAttribute
  }

  open override func layoutAttributesForSupplementaryView(ofKind elementKind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> LayoutAttributes? {
    let sectionAttributes = layoutAttributes[indexPath.section]
    var layoutAttributesResult: LayoutAttributes? = nil

    switch elementKind {
    case .sectionHeader:
      layoutAttributesResult = sectionAttributes.filter({ $0.representedElementCategory == .supplementaryView }).first
    case .sectionFooter:
      layoutAttributesResult = sectionAttributes.filter({ $0.representedElementCategory == .supplementaryView }).last
    default:
      return nil
    }

    return layoutAttributesResult
  }
}
