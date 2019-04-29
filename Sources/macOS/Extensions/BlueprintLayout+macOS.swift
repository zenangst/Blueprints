import Cocoa

extension BlueprintLayout {
  open override func layoutAttributesForSupplementaryView(ofKind elementKind: NSCollectionView.SupplementaryElementKind,
                                                          at indexPath: IndexPath) -> LayoutAttributes? {
    if indexPathIsOutOfBounds(indexPath, for: cachedSupplementaryAttributesBySection) {
        return nil
    }

    let sectionAttributes = cachedSupplementaryAttributesBySection[indexPath.section]
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
    macOSWorkaroundSetNewContentSize()
  }

  /// On macOS, collection views that don't have an initial size won't
  /// try and invalidate its layout attributes when updates happen if the
  /// collection views size is zero. To work around this issue,
  /// the collection will get half a pixel and an alpha value that is not
  /// visible to the user. That way it can respond to updates and invalidate
  /// properly. If a hidden collection view gets a new content size
  /// it will restore the alpha value to 1.0, but only if the alpha value
  /// is equal to the workaround value.
  func macOSWorkaroundCreateCache() {
    let alphaValue: CGFloat = 0.0001
    if contentSize.height == 0 && collectionView?.alphaValue != 0.0 {
      contentSize.height = super.collectionViewContentSize.height
      collectionView?.alphaValue = alphaValue
    } else if collectionView?.alphaValue == alphaValue {
      collectionView?.alphaValue = 1.0
    }
    collectionView?.frame.size.height = contentSize.height
  }

  /// When transitioning between layouts macOS does not set the
  /// proper size to the document view of the scroll view.
  /// To work around this, the collection views window will
  /// temporarily be resized and then restored. This will
  /// trigger the document view getting the new size.
  func macOSWorkaroundSetNewContentSize() {
    if let window = collectionView?.window {
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      CATransaction.setAnimationDuration(0.0)
      let originalFrame = window.frame
      var frame = originalFrame
      frame.origin.y = frame.origin.y - 0.025
      frame.size.height = frame.size.height + 0.025
      frame.size.width = frame.size.width + 0.025
      window.setFrame(frame, display: false)
      CATransaction.commit()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.045) {
        window.setFrame(originalFrame, display: false)
      }
    }
  }

  func configureSupplementaryWidth(_ view: NSView) {
    supplementaryWidth = view.frame.width
  }

  @objc func contentViewBoundsDidChange(_ notification: NSNotification) {
    guard let clipView = notification.object as? NSClipView,
      clipView == collectionView?.enclosingScrollView else {
        return
    }
    collectionView?.enclosingScrollView?.layout()
    configureSupplementaryWidth(clipView)
  }
}
