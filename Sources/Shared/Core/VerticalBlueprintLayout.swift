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
  ///   - estimatedItemSize: The estimated size to use for cells.
  ///   - minimumInteritemSpacing: The minimum spacing to use between items in the same row.
  ///   - minimumLineSpacing: The minimum spacing to use between lines of items in the grid.
  ///   - sectionInset: The margins used to lay out content in a section
  ///   - stickyHeaders: A Boolean value indicating whether headers pin to the top of the collection view bounds during scrolling.
  ///   - stickyFooters: A Boolean value indicating whether footers pin to the top of the collection view bounds during scrolling.
  ///   - animator: The animator that should be used for the layout, defaults to `DefaultLayoutAnimator`.
  @objc private init(itemsPerRow: CGFloat = 0.0,
                     itemSize: CGSize = CGSize(width: 50, height: 50),
                     estimatedItemSize: CGSize = .zero,
                     minimumInteritemSpacing: CGFloat = 0,
                     minimumLineSpacing: CGFloat = 10,
                     sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                     stickyHeaders: Bool = false,
                     stickyFooters: Bool = false,
                     animator: BlueprintLayoutAnimator = DefaultLayoutAnimator(animation: .automatic)) {
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

  /// An initialized vertical collection view layout object.
  ///
  /// - Parameters:
  ///   - itemSize: The default size to use for cells.
  ///   - minimumInteritemSpacing: The minimum spacing to use between items in the same row.
  ///   - minimumLineSpacing: The minimum spacing to use between lines of items in the grid.
  ///   - sectionInset: The margins used to lay out content in a section
  ///   - stickyHeaders: A Boolean value indicating whether headers pin to the top of the collection view bounds during scrolling.
  ///   - stickyFooters: A Boolean value indicating whether footers pin to the top of the collection view bounds during scrolling.
  ///   - animator: The animator that should be used for the layout, defaults to `DefaultLayoutAnimator`.
  @objc public convenience init(itemSize: CGSize = CGSize(width: 50, height: 50),
                          minimumInteritemSpacing: CGFloat = 0,
                          minimumLineSpacing: CGFloat = 10,
                          sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                          stickyHeaders: Bool = false,
                          stickyFooters: Bool = false,
                          animator: BlueprintLayoutAnimator = DefaultLayoutAnimator(animation: .automatic)) {
    self.init(itemsPerRow: 0.0,
              itemSize: itemSize,
              estimatedItemSize: .zero,
              minimumInteritemSpacing: minimumInteritemSpacing,
              minimumLineSpacing: minimumLineSpacing,
              sectionInset: sectionInset,
              stickyHeaders: stickyHeaders,
              stickyFooters: stickyFooters,
              animator: animator)
  }

  /// An initialized vertical collection view layout object.
  ///
  /// - Parameters:
  ///   - itemsPerRow: The amount of items that should appear on each row.
  ///   - height: The height for the cells.
  ///   - minimumInteritemSpacing: The minimum spacing to use between items in the same row.
  ///   - minimumLineSpacing: The minimum spacing to use between lines of items in the grid.
  ///   - sectionInset: The margins used to lay out content in a section
  ///   - stickyHeaders: A Boolean value indicating whether headers pin to the top of the collection view bounds during scrolling.
  ///   - stickyFooters: A Boolean value indicating whether footers pin to the top of the collection view bounds during scrolling.
  ///   - animator: The animator that should be used for the layout, defaults to `DefaultLayoutAnimator`.
  @objc public convenience init(itemsPerRow: CGFloat = 0.0,
                          height: CGFloat = 50,
                          minimumInteritemSpacing: CGFloat = 0,
                          minimumLineSpacing: CGFloat = 10,
                          sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                          stickyHeaders: Bool = false,
                          stickyFooters: Bool = false,
                          animator: BlueprintLayoutAnimator = DefaultLayoutAnimator(animation: .automatic)) {
    let size = CGSize(width: 50, height: height)
    self.init(itemsPerRow: itemsPerRow,
              itemSize: size,
              estimatedItemSize: .zero,
              minimumInteritemSpacing: minimumInteritemSpacing,
              minimumLineSpacing: minimumLineSpacing,
              sectionInset: sectionInset,
              stickyHeaders: stickyHeaders,
              stickyFooters: stickyFooters,
              animator: animator)
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
          sectionMaxY = layoutAttribute.frame.maxY
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

          if stickyFooters {
            let heightThreshold: CGFloat
            #if os(macOS)
              heightThreshold = collectionView.enclosingScrollView?.bounds.height ?? collectionView.bounds.height
            #else
              heightThreshold = collectionView.bounds.height
            #endif
            let footerY = min(
              max(collectionView.contentOffset.y + heightThreshold - footerReferenceSize.height,
                  firstItem.frame.minY),
              sectionMaxY + sectionInset.bottom)

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

  override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    var shouldInvalidate = stickyFooters || stickyHeaders

    if contentSize.width != newBounds.size.width {
      shouldInvalidate = true
    }

    return shouldInvalidate
  }
}
