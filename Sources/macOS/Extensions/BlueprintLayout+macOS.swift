import Cocoa

extension BlueprintLayout {
  open override func layoutAttributesForSupplementaryView(ofKind elementKind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> LayoutAttributes? {
    if indexPathIsOutOfBounds(indexPath, for: cachedAttributes) {
        return nil
    }

    let sectionAttributes = cachedAttributes[indexPath.section]
    var layoutAttributesResult: LayoutAttributes? = nil

    switch elementKind {
    case NSCollectionView.elementKindSectionHeader:
      layoutAttributesResult = sectionAttributes.filter({ $0.representedElementCategory == .supplementaryView }).first
    case NSCollectionView.elementKindSectionFooter:
      layoutAttributesResult = sectionAttributes.filter({ $0.representedElementCategory == .supplementaryView }).last
    default:
      return nil
    }

    return layoutAttributesResult
  }

  open override func finalizeLayoutTransition() {
    super.finalizeLayoutTransition()
    collectionView?.enclosingScrollView?.layout()
  }

  /// On macOS, collection views that don't have an initial size won't
  /// try and invalidate its layout attributes when updates happen if the
  /// collection views size is zero. To work around this issue,
  /// the collection will get half a pixel and an alpha value that is not
  /// visible to the user. That way it can respond to updates and invalidate
  /// properly. If a hidden collection view gets a new content size
  /// it will restore the alpha value to 1.0, but only if the alpha value
  /// is equal to the workaround value.
  func macOSWorkaround() {
    let alphaValue: CGFloat = 0.0001
    if contentSize.height == 0 && collectionView?.alphaValue != 0.0 {
      contentSize.height = 0.5
      collectionView?.alphaValue = alphaValue
    } else if collectionView?.alphaValue == alphaValue {
      collectionView?.alphaValue = 1.0
    }
    collectionView?.frame.size.height = contentSize.height
  }

  func configureHeaderFooterWidth(_ view: NSView) {
    headerFooterWidth = view.frame.width
  }

  // TEMP Comment - Remove - Required to resolve #77
  @objc func contentViewBoundsDidChange(_ notification: NSNotification) {
    guard let clipView = notification.object as? NSClipView,
      clipView == collectionView?.enclosingScrollView else {
        return
    }
    collectionView?.enclosingScrollView?.layout()
    configureHeaderFooterWidth(clipView)
  }
}
