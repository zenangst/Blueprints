#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

@objc open class VerticalBlueprintLayout: BlueprintLayout {
  //  A Boolean value indicating whether headers pin to the top of the collection view bounds during scrolling.
  public var stickyHeaders: Bool = false
  /// A Boolean value indicating whether footers pin to the top of the collection view bounds during scrolling.
  public var stickyFooters: Bool = false

  /// An initialized vertical collection view layout object.
  ///
  /// - Parameters:
  ///   - itemsPerRow: The amount of items that should appear on each row.
  ///   - itemSize: The default size to use for cells.
  ///   - minimumInteritemSpacing: The minimum spacing to use between items in the same row.
  ///   - minimumLineSpacing: The minimum spacing to use between lines of items in the grid.
  ///   - sectionInset: The margins used to lay out content in a section
  ///   - stickyHeaders: A Boolean value indicating whether headers pin to the top of the collection view bounds during scrolling.
  ///   - stickyFooters: A Boolean value indicating whether footers pin to the top of the collection view bounds during scrolling.
  ///   - animator: The animator that should be used for the layout, defaults to `DefaultLayoutAnimator`.
  @objc required public init(
    itemsPerRow: CGFloat = 0.0,
    itemSize: CGSize = CGSize(width: 50, height: 50),
    estimatedItemSize: CGSize = .zero,
    minimumInteritemSpacing: CGFloat = 0,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    stickyHeaders: Bool = false,
    stickyFooters: Bool = false,
    animator: BlueprintLayoutAnimator = DefaultLayoutAnimator(animation: .automatic)
    ) {
    self.stickyHeaders = stickyHeaders
    self.stickyFooters = stickyFooters
    super.init(
      itemsPerRow: itemsPerRow,
      itemSize: itemSize,
      estimatedItemSize: estimatedItemSize,
      minimumInteritemSpacing: minimumInteritemSpacing,
      minimumLineSpacing: minimumLineSpacing,
      sectionInset: sectionInset,
      animator: animator
    )
    self.scrollDirection = .vertical
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func prepare() {
    super.prepare()
    var layoutAttributes = self.cachedAttributes
    var threshold: CGFloat = 0.0

    if let collectionViewWidth = collectionView?.documentRect.width {
      threshold = collectionViewWidth
    }

    var nextY: CGFloat = 0

    for section in 0..<numberOfSections {
      guard numberOfItemsInSection(section) > 0 else {
        continue
      }

      var firstItem: LayoutAttributes? = nil
      var previousItem: LayoutAttributes? = nil
      var headerAttribute: LayoutAttributes? = nil
      var footerAttribute: LayoutAttributes? = nil
      let sectionIndexPath = IndexPath(item: 0, section: section)

      if headerReferenceSize.height > 0 {
        let layoutAttribute = createSupplementaryLayoutAttribute(
          ofKind: .header,
          indexPath: sectionIndexPath,
          atY: nextY
        )
        layoutAttribute.frame.size.width = collectionView?.documentRect.width ?? headerReferenceSize.width
        layoutAttributes.append([layoutAttribute])
        headerAttribute = layoutAttribute
        nextY = layoutAttribute.frame.maxY
      }

      nextY += sectionInset.top
      var sectionMaxY: CGFloat = 0

      for item in 0..<numberOfItemsInSection(section) {
        let indexPath = IndexPath(item: item, section: section)
        let layoutAttribute = LayoutAttributes.init(forCellWith: indexPath)

        defer { previousItem = layoutAttribute }

        layoutAttribute.size = resolveSizeForItem(at: indexPath)

        if let previousItem = previousItem {
          var minY: CGFloat = previousItem.frame.origin.y
          var maxY: CGFloat = previousItem.frame.maxY

          // Properly align the current item with the previous item at the same
          // x offset. This helps ensure that the layout renders correctly when
          // using layout attributes with dynamic height.
          if let itemsPerRow = itemsPerRow,
            itemsPerRow > 1,
            item > Int(itemsPerRow) - 1,
            Int(itemsPerRow) - 1 < layoutAttributes[section].count {
            let previousXOffset = item - Int(itemsPerRow - indexOffsetForSectionHeaders())
            let lookupAttribute = layoutAttributes[section][previousXOffset]
            maxY = lookupAttribute.frame.maxY
            minY = lookupAttribute.frame.maxY + minimumLineSpacing
          }

          layoutAttribute.frame.origin.x = previousItem.frame.maxX + minimumInteritemSpacing
          layoutAttribute.frame.origin.y = minY

          if layoutAttribute.frame.maxX > threshold {
            layoutAttribute.frame.origin.x = sectionInset.left
            layoutAttribute.frame.origin.y = maxY + minimumLineSpacing
          }

          sectionMaxY = max(previousItem.frame.maxY, layoutAttribute.frame.maxY)
        } else {
          firstItem = layoutAttribute
          layoutAttribute.frame.origin.x = sectionInset.left
          layoutAttribute.frame.origin.y = nextY
        }

        if section == layoutAttributes.count {
          layoutAttributes.append([layoutAttribute])
        } else {
          layoutAttributes[section].append(layoutAttribute)
        }
      }

      if let previousItem = previousItem, let firstItem = firstItem {
        nextY = previousItem.frame.maxY
        if footerReferenceSize.height > 0 {
          let layoutAttribute = createSupplementaryLayoutAttribute(
            ofKind: .footer,
            indexPath: sectionIndexPath,
            atY: sectionMaxY + sectionInset.bottom
          )
          layoutAttributes[section].append(layoutAttribute)
          footerAttribute = layoutAttribute
          nextY = layoutAttribute.frame.maxY
        }

        if let collectionView = collectionView,
          let headerFooterWidth = headerFooterWidth {
          var contentInsetTop: CGFloat = 0
          #if os(macOS)
            contentInsetTop = (collectionView.enclosingScrollView?.enclosingScrollView?.contentInsets.top ?? 0)
            if section == 0 && collectionView.contentOffset.y == 0 {
              contentInsetTop = 0
            }
          #endif

          if stickyHeaders {
            let headerY = min(
              max(collectionView.contentOffset.y + contentInsetTop,
                  firstItem.frame.origin.y - headerReferenceSize.height - sectionInset.top),
              previousItem.frame.maxY - headerReferenceSize.height + sectionInset.bottom)

            headerAttribute?.zIndex = numberOfSections
            headerAttribute?.frame.origin.y = headerY
            headerAttribute?.frame.size.width = headerFooterWidth
          }

          // TODO: - Existing header logic will not work and will need to be re-worked.
          if stickyFooters {
            let footerY = min(
              max(collectionView.contentOffset.y + contentInsetTop,
                  firstItem.frame.origin.y - headerReferenceSize.height - sectionInset.top),
              previousItem.frame.maxY - headerReferenceSize.height + sectionInset.bottom)

            footerAttribute?.zIndex = numberOfSections
            footerAttribute?.frame.origin.y = footerY
            footerAttribute?.frame.size.width = headerFooterWidth
          }
        }

        contentSize.height = sectionMaxY - headerReferenceSize.height + sectionInset.bottom
      }

      previousItem = nil
      headerAttribute = nil
      footerAttribute = nil
      firstItem = nil
    }

    contentSize.width = threshold
    contentSize.height += headerReferenceSize.height + footerReferenceSize.height


    self.contentSize = contentSize
    createCache(with: layoutAttributes)
  }
}

extension VerticalBlueprintLayout {

  // TODO: - Performance investigation
  override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  /*override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> LayoutAttributes? {
    if indexPathIsOutOfBounds(indexPath, for: cachedAttributes) {
      return nil
    }

    let sectionAttributes = cachedAttributes[indexPath.section]
    var layoutAttributesResult: LayoutAttributes? = nil

    switch elementKind {
    case CollectionView.collectionViewHeaderType:
      if stickyHeaders {
        layoutAttributesResult = adjustedLayoutAttributesForStickyHeader(layoutAttributes: sectionAttributes.filter({ $0.representedElementCategory == .supplementaryView }).first,
                                                                         at: indexPath)
      } else {
        layoutAttributesResult = sectionAttributes.filter({ $0.representedElementCategory == .supplementaryView }).first
      }
    case CollectionView.collectionViewFooterType:
      if stickyFooters {
        layoutAttributesResult = adjustedLayoutAttributesForStickyFooter(layoutAttributes: sectionAttributes.filter({ $0.representedElementCategory == .supplementaryView }).last,
                                                                         at: indexPath)
      } else {
        layoutAttributesResult = sectionAttributes.filter({ $0.representedElementCategory == .supplementaryView }).last
      }
    default:
      return nil
    }

    return layoutAttributesResult
  }

  private func adjustedLayoutAttributesForStickyHeader(layoutAttributes: LayoutAttributes?, at indexPath: IndexPath) -> LayoutAttributes? {
    guard let layoutAttributes = layoutAttributes,
      let collectionView = collectionView,
      let boundaries = boundaries(forSection: indexPath.section) else {
        return nil
    }

    let contentOffsetY = collectionView.contentOffset.y
    var frameForSupplementaryHeaderView = layoutAttributes.frame
    let minimum = boundaries.minimum - frameForSupplementaryHeaderView.height
    let maximum = boundaries.maximum - frameForSupplementaryHeaderView.height

    if contentOffsetY < minimum {
      frameForSupplementaryHeaderView.origin.y = minimum
    } else if contentOffsetY > maximum {
      frameForSupplementaryHeaderView.origin.y = maximum
    } else {
      frameForSupplementaryHeaderView.origin.y = contentOffsetY
    }

    layoutAttributes.frame = frameForSupplementaryHeaderView

    return layoutAttributes
  }

  private func adjustedLayoutAttributesForStickyFooter(layoutAttributes: LayoutAttributes?, at indexPath: IndexPath) -> LayoutAttributes? {
    guard let layoutAttributes = layoutAttributes,
      let collectionView = collectionView,
      let boundaries = footerBoundaries(forSection: indexPath.section) else {
        return nil
    }

    let contentOffsetY = collectionView.contentOffset.y
    var frameForSupplementaryHeaderView = layoutAttributes.frame
    let minimum = boundaries.minimum - frameForSupplementaryHeaderView.height
    let maximum = boundaries.maximum - frameForSupplementaryHeaderView.height

    if contentOffsetY < minimum {
      frameForSupplementaryHeaderView.origin.y = minimum
    } else if contentOffsetY > maximum {
      frameForSupplementaryHeaderView.origin.y = maximum
    } else {
      frameForSupplementaryHeaderView.origin.y = contentOffsetY
    }

    layoutAttributes.frame = frameForSupplementaryHeaderView

    return layoutAttributes
  }

  // TODO: - Rename to boundariesForHorizontalLayout? move to parent as this will be reused in other layouts?
  private func boundaries(forSection section: Int) -> (minimum: CGFloat, maximum: CGFloat)? {
    var result = (minimum: CGFloat(0.0), maximum: CGFloat(0.0))
    guard let collectionView = collectionView else {
      return result
    }

    let numberOfItemsInSection = collectionView.numberOfItems(inSection: section)
    guard numberOfItemsInSection > 0 else {
      return result
    }

    let indexOffset = 1
    let firstItemsIndexPath = IndexPath(item: 0, section: section)
    let lastItemsIndexPath = IndexPath(item: numberOfItemsInSection - indexOffset, section: section)

    if let firstItem = layoutAttributesForItem(at: firstItemsIndexPath),
      let lastItem = layoutAttributesForItem(at: lastItemsIndexPath) {
      result.minimum = firstItem.frame.minY
      result.maximum = lastItem.frame.maxY
      result.minimum -= headerReferenceSize.height
      result.maximum -= headerReferenceSize.height
      result.minimum -= sectionInset.top
      result.maximum += (sectionInset.top + sectionInset.bottom)
    }

    return result
  }

  private func footerBoundaries(forSection section: Int) -> (minimum: CGFloat, maximum: CGFloat)? {
    var result = (minimum: CGFloat(0.0), maximum: CGFloat(0.0))
    guard let collectionView = collectionView else {
      return result
    }

    let numberOfItemsInSection = collectionView.numberOfItems(inSection: section)
    guard numberOfItemsInSection > 0 else {
      return result
    }

    let indexOffset = 1
    let firstItemsIndexPath = IndexPath(item: 0, section: section)
    let lastItemsIndexPath = IndexPath(item: numberOfItemsInSection - indexOffset, section: section)

    if let firstItem = layoutAttributesForItem(at: firstItemsIndexPath),
      let lastItem = layoutAttributesForItem(at: lastItemsIndexPath) {
      result.minimum = lastItem.frame.minY//firstItem.frame.minY
      result.maximum = lastItem.frame.maxY//lastItem.frame.maxY
      result.minimum -= headerReferenceSize.height
      result.maximum -= headerReferenceSize.height
      result.minimum -= sectionInset.top
      result.maximum += (sectionInset.top + sectionInset.bottom)
    }

    return result
  }*/
}
