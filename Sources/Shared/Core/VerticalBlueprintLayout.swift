#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

@objc open class VerticalBlueprintLayout: BlueprintLayout {
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
  @objc private override init(itemsPerRow: CGFloat = 0.0,
                              itemSize: CGSize = CGSize(width: 50, height: 50),
                              estimatedItemSize: CGSize = .zero,
                              minimumInteritemSpacing: CGFloat = 0,
                              minimumLineSpacing: CGFloat = 10,
                              sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                              stickyHeaders: Bool = false,
                              stickyFooters: Bool = false,
                              animator: BlueprintLayoutAnimator = DefaultLayoutAnimator(animation: .automatic)) {
    super.init(
      itemsPerRow: itemsPerRow,
      itemSize: itemSize,
      estimatedItemSize: estimatedItemSize,
      minimumInteritemSpacing: minimumInteritemSpacing,
      minimumLineSpacing: minimumLineSpacing,
      sectionInset: sectionInset,
      stickyHeaders: stickyHeaders,
      stickyFooters: stickyFooters,
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
                          animator: BlueprintLayoutAnimator = DefaultLayoutAnimator()) {
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
    guard prepareAllowed else {
        return
    }
    prepareAllowed = false

    super.prepare()

    var layoutAttributes = [[LayoutAttributes]]()
    var threshold: CGFloat = 0.0

    if let collectionViewWidth = collectionView?.documentRect.width {
      threshold = collectionViewWidth
    }

    var nextY: CGFloat = 0

    for section in 0..<numberOfSections {
      guard numberOfItemsInSection(section) > 0 else {
        layoutAttributes.append([])
        continue
      }

      var previousAttribute: LayoutAttributes? = nil
      var headerAttribute: SupplementaryLayoutAttributes? = nil
      let sectionIndexPath = IndexPath(item: 0, section: section)
      let sectionsMinimumInteritemSpacing = resolveMinimumInteritemSpacing(forSectionAt: section)
      let sectionsMinimumLineSpacing = resolveMinimumLineSpacing(forSectionAt: section)

      if resolveSizeForSupplementaryView(ofKind: .header, at: sectionIndexPath).height > 0 {
        let layoutAttribute = SupplementaryLayoutAttributes(
          forSupplementaryViewOfKind: BlueprintSupplementaryKind.header.collectionViewSupplementaryType,
          with: sectionIndexPath
        )
        layoutAttribute.size = resolveSizeForSupplementaryView(ofKind: .header, at: sectionIndexPath)
        layoutAttribute.zIndex = section + numberOfItemsInSection(section)
        layoutAttribute.min = nextY
        layoutAttribute.frame.origin.x = 0
        layoutAttribute.frame.origin.y = nextY
        layoutAttributes.append([layoutAttribute])
        headerAttribute = layoutAttribute
        nextY = layoutAttribute.frame.maxY
      }

      nextY += sectionInset.top
      var sectionMaxY: CGFloat = 0

      for item in 0..<numberOfItemsInSection(section) {
        let indexPath = IndexPath(item: item, section: section)
        let layoutAttribute = LayoutAttributes.init(forCellWith: indexPath)

        defer { previousAttribute = layoutAttribute }

        layoutAttribute.size = resolveSizeForItem(at: indexPath)

        if let previousItem = previousAttribute {
          var minY: CGFloat = previousItem.frame.origin.y
          var maxY: CGFloat = previousItem.frame.maxY

          // Properly align the current item with the previous item at the same
          // x offset. This helps ensure that the layout renders correctly when
          // using layout attributes with dynamic height.
          if let itemsPerRow = itemsPerRow,
            itemsPerRow > 1,
            item > Int(itemsPerRow) - 1,
            Int(itemsPerRow) - 1 < layoutAttributes[section].count {
            let previousXOffset = item - Int(itemsPerRow - indexOffsetForSectionHeaders(at: sectionIndexPath))
            let lookupAttribute = layoutAttributes[section][previousXOffset]
            maxY = lookupAttribute.frame.maxY
            minY = lookupAttribute.frame.maxY + sectionsMinimumLineSpacing
          }

          layoutAttribute.frame.origin.x = previousItem.frame.maxX + sectionsMinimumInteritemSpacing
          layoutAttribute.frame.origin.y = minY

          if layoutAttribute.frame.maxX > threshold {
            layoutAttribute.frame.origin.x = sectionInset.left
            layoutAttribute.frame.origin.y = maxY + sectionsMinimumLineSpacing
          }

          sectionMaxY = max(sectionMaxY, layoutAttribute.frame.maxY)
        } else {
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

      let sectionsHeaderReferenceSize = resolveSizeForSupplementaryView(ofKind: .header, at: sectionIndexPath)
      headerAttribute?.max = sectionMaxY + sectionInset.bottom - sectionsHeaderReferenceSize.height

      if let previousItem = previousAttribute {
        let sectionsFooterReferenceSize = resolveSizeForSupplementaryView(ofKind: .footer, at: sectionIndexPath)
        let previousY = nextY
        nextY = previousItem.frame.maxY
        if sectionsFooterReferenceSize.height > 0 {
          let layoutAttribute = SupplementaryLayoutAttributes(
            forSupplementaryViewOfKind: BlueprintSupplementaryKind.footer.collectionViewSupplementaryType,
            with: sectionIndexPath
          )
          layoutAttribute.size = sectionsFooterReferenceSize
          layoutAttribute.zIndex = section + numberOfItemsInSection(section)
          layoutAttribute.min = headerAttribute?.frame.maxY ?? previousY
          layoutAttribute.max = sectionMaxY + sectionInset.bottom
          layoutAttribute.frame.origin.x = 0
          layoutAttribute.frame.origin.y = sectionMaxY + sectionInset.bottom
          layoutAttributes[section].append(layoutAttribute)
          nextY = layoutAttribute.frame.maxY
        } else {
          nextY = sectionMaxY + sectionInset.bottom
        }
        contentSize.height = sectionMaxY - sectionsHeaderReferenceSize.height + sectionInset.bottom
        headerAttribute?.max = contentSize.height
      }
      previousAttribute = nil
      headerAttribute = nil
    }

    let indexOffset = 1
    let lastHeaderReferenceHeight = resolveSizeForSupplementaryView(ofKind: .header, at: IndexPath(item: 0, section: numberOfSections)).height
    let lastFooterReferenceHeight = resolveSizeForSupplementaryView(ofKind: .footer, at: IndexPath(item: numberOfItemsInSection(numberOfSections - indexOffset), section: numberOfSections)).height
    contentSize.height += lastHeaderReferenceHeight + lastFooterReferenceHeight
    contentSize.width = threshold

    self.contentSize = contentSize
    createCache(with: layoutAttributes)
    if stickyHeaders || stickyFooters {
      positionHeadersAndFooters()
    }
  }
}
