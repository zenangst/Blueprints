import Cocoa

extension BlueprintLayout {
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

  func configureHeaderFooterWidth(_ view: NSView) {
    headerFooterWidth = view.frame.width
  }

  @objc func contentViewBoundsDidChange(_ notification: NSNotification) {
    guard let clipView = notification.object as? NSClipView,
      clipView == collectionView?.enclosingScrollView?.contentView else {
        return
    }

    configureHeaderFooterWidth(clipView)
  }
}
