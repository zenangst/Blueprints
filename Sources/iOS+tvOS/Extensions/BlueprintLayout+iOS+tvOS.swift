import UIKit

extension BlueprintLayout {
  open override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                          at indexPath: IndexPath) -> LayoutAttributes? {
    if indexPathIsOutOfBounds(indexPath, for: cachedHeaderFooterAttributesBySection) {
        return nil
    }

    let sectionAttributes = cachedHeaderFooterAttributesBySection[indexPath.section]
    var layoutAttributesResult: LayoutAttributes? = nil

    switch elementKind {
    case CollectionView.collectionViewHeaderType:
      layoutAttributesResult = sectionAttributes.filter({ $0.representedElementCategory == .supplementaryView }).first
    case CollectionView.collectionViewFooterType:
      layoutAttributesResult = sectionAttributes.filter({ $0.representedElementCategory == .supplementaryView }).last
    default:
      return nil
    }

    return layoutAttributesResult
  }
}
