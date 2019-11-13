#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

@objc open class HorizontalBlueprintLayout: BlueprintLayout {
  /// A Integer value indicating how many items that should be visible per column.
  public var itemsPerColumn: Int

  /// An initialized vertical collection view layout object.
  ///
  /// - Parameters:
  ///   - itemsPerRow: The amount of items that should appear on each row.
  ///   - itemsPerColumn: The amount of items that should appear per column.
  ///   - itemSize: The default size to use for cells.
  ///   - estimatedItemSize: The estimated size to use for cells.
  ///   - minimumInteritemSpacing: The minimum spacing to use between items in the same row.
  ///   - minimumLineSpacing: The minimum spacing to use between lines of items in the grid.
  ///   - sectionInset: The margins used to lay out content in a section
  ///   - stickyHeaders: A Boolean value indicating whether headers pin to the top of the collection view bounds during scrolling.
  ///   - stickyFooters: A Boolean value indicating whether footers pin to the top of the collection view bounds during scrolling.
  ///   - animator: The animator that should be used for the layout, defaults to `DefaultLayoutAnimator`.
  @objc private init(itemsPerRow: CGFloat = 0.0,
                     itemsPerColumn: Int = 1,
                     itemSize: CGSize = CGSize(width: 50, height: 50),
                     estimatedItemSize: CGSize = .zero,
                     minimumInteritemSpacing: CGFloat = 10,
                     minimumLineSpacing: CGFloat = 10,
                     sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                     stickyHeaders: Bool = true,
                     stickyFooters: Bool = true,
                     animator: BlueprintLayoutAnimator = DefaultLayoutAnimator()) {
    self.itemsPerColumn = itemsPerColumn
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
    self.scrollDirection = .horizontal
  }

  /// An initialized vertical collection view layout object.
  ///
  /// - Parameters:
  ///   - itemsPerRow: The amount of items that should appear on each row.
  ///   - itemsPerColumn: The amount of items that should appear per column.
  ///   - height: The height for the cells.
  ///   - minimumInteritemSpacing: The minimum spacing to use between items in the same row.
  ///   - minimumLineSpacing: The minimum spacing to use between lines of items in the grid.
  ///   - sectionInset: The margins used to lay out content in a section
  ///   - stickyHeaders: A Boolean value indicating whether headers pin to the top of the collection view bounds during scrolling.
  ///   - stickyFooters: A Boolean value indicating whether footers pin to the top of the collection view bounds during scrolling.
  ///   - animator: The animator that should be used for the layout, defaults to `DefaultLayoutAnimator`.
  @objc required public convenience init(
    itemsPerRow: CGFloat = 0.0,
    itemsPerColumn: Int = 1,
    height: CGFloat = 50,
    minimumInteritemSpacing: CGFloat = 10,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    stickyHeaders: Bool = true,
    stickyFooters: Bool = true,
    animator: BlueprintLayoutAnimator = DefaultLayoutAnimator()
    ) {
    self.init(itemsPerRow: itemsPerRow,
              itemsPerColumn: itemsPerColumn,
              itemSize: CGSize(width: 50, height: height),
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
  ///   - itemsPerColumn: The amount of items that should appear per column.
  ///   - itemSize: The default size to use for cells.
  ///   - minimumInteritemSpacing: The minimum spacing to use between items in the same row.
  ///   - minimumLineSpacing: The minimum spacing to use between lines of items in the grid.
  ///   - sectionInset: The margins used to lay out content in a section
  ///   - stickyHeaders: A Boolean value indicating whether headers pin to the top of the collection view bounds during scrolling.
  ///   - stickyFooters: A Boolean value indicating whether footers pin to the top of the collection view bounds during scrolling.
  ///   - animator: The animator that should be used for the layout, defaults to `DefaultLayoutAnimator`.
  @objc required public convenience init(
    itemsPerColumn: Int = 1,
    itemSize: CGSize = CGSize(width: 50, height: 50),
    minimumInteritemSpacing: CGFloat = 10,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    stickyHeaders: Bool = true,
    stickyFooters: Bool = true,
    animator: BlueprintLayoutAnimator = DefaultLayoutAnimator()
    ) {
    self.init(itemsPerRow: 0.0,
              itemsPerColumn: itemsPerColumn,
              itemSize: itemSize,
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

    let sections = numberOfSections
    var layoutAttributes = Array<[LayoutAttributes]>.init(repeating: [LayoutAttributes](),
                                                          count: sections)
    var contentSize: CGSize = .zero
    var nextX: CGFloat = 0
    var widthOfSection: CGFloat = 0

    for section in 0..<sections {
      let numberOfItems = numberOfItemsInSection(section)
      guard numberOfItems > 0 else {
        continue
      }
      widthOfSection = 0
      var firstItem: LayoutAttributes? = nil
      var previousItem: LayoutAttributes? = nil
      var headerAttribute: SupplementaryLayoutAttributes? = nil
      var footerAttribute: SupplementaryLayoutAttributes? = nil
      let sectionIndexPath = IndexPath(item: 0, section: section)
      let sectionsMinimumInteritemSpacing = resolveMinimumInteritemSpacing(forSectionAt: section)
      let sectionsMinimumLineSpacing = resolveMinimumLineSpacing(forSectionAt: section)
      let headerSize = resolveSizeForSupplementaryView(ofKind: .header, at: sectionIndexPath)

      if headerSize.height > 0 {
        let layoutAttribute = SupplementaryLayoutAttributes(
          forSupplementaryViewOfKind: BlueprintSupplementaryKind.header.collectionViewSupplementaryType,
          with: sectionIndexPath
        )
        layoutAttribute.size = headerSize
        layoutAttribute.zIndex = section + numberOfItems
        layoutAttribute.min = nextX
        layoutAttribute.frame.origin.x = nextX
        layoutAttribute.frame.origin.y = 0
        layoutAttributes[section].append(layoutAttribute)
        headerAttribute = layoutAttribute
      }

      var sectionMaxY: CGFloat = 0

      for item in 0..<numberOfItems {
        let indexPath = IndexPath(item: item, section: section)
        let layoutAttribute = LayoutAttributes(forCellWith: indexPath)

        defer { previousItem = layoutAttribute }

        layoutAttribute.size = resolveSizeForItem(at: indexPath)
        layoutAttribute.frame.origin.y = sectionInset.top + headerSize.height

        if item > 0, let previousItem = previousItem {
          layoutAttribute.frame.origin.x = previousItem.frame.maxX + sectionsMinimumInteritemSpacing

          if itemsPerColumn > 1 && !(item % itemsPerColumn == 0) {
            layoutAttribute.frame.origin.x = previousItem.frame.origin.x
            layoutAttribute.frame.origin.y = previousItem.frame.maxY + sectionsMinimumLineSpacing
          } else {
            widthOfSection += layoutAttribute.size.width + sectionsMinimumInteritemSpacing
          }
        } else {
          firstItem = layoutAttribute
          layoutAttribute.frame.origin.x = nextX + sectionInset.left
          widthOfSection += sectionInset.left + sectionInset.right + layoutAttribute.size.width
        }

        sectionMaxY = max(sectionMaxY, layoutAttribute.frame.maxY)
        layoutAttributes[section].append(layoutAttribute)
      }

      if let previousItem = previousItem, let firstItem = firstItem {
        contentSize.width = previousItem.frame.maxX + sectionInset.right

        let footerSize = resolveSizeForSupplementaryView(ofKind: .footer, at: sectionIndexPath)
        if footerSize.height > 0 {
          let layoutAttribute = SupplementaryLayoutAttributes(
            forSupplementaryViewOfKind: BlueprintSupplementaryKind.footer.collectionViewSupplementaryType,
            with: sectionIndexPath
          )
          layoutAttribute.size = footerSize
          layoutAttribute.zIndex = section + numberOfItems
          layoutAttribute.min = nextX
          layoutAttribute.frame.origin.x = 0
          layoutAttribute.frame.origin.y = sectionMaxY + sectionInset.bottom
          layoutAttributes[section].append(layoutAttribute)
          footerAttribute = layoutAttribute
        }

        if let collectionView = collectionView {
          let supplementaryX = max(
            min(collectionView.contentOffset.x, previousItem.frame.maxX - supplementaryWidth + sectionInset.left),
            firstItem.frame.origin.x - sectionInset.left
          )

          if stickyHeaders {
            headerAttribute?.frame.origin.x = supplementaryX
            headerAttribute?.frame.size.width = min(supplementaryWidth, widthOfSection)
          } else {
            headerAttribute?.frame.size.width = widthOfSection
          }

          if stickyFooters {
            footerAttribute?.frame.origin.x = supplementaryX
            footerAttribute?.frame.size.width = min(supplementaryWidth, widthOfSection)
          } else {
            footerAttribute?.frame.size.width = widthOfSection
          }
        }

        contentSize.height = sectionMaxY - headerSize.height + sectionInset.bottom
        nextX += widthOfSection
      }

      headerAttribute?.max = contentSize.width
      footerAttribute?.max = contentSize.width

      previousItem = nil
      headerAttribute = nil
      footerAttribute = nil
      firstItem = nil
    }

    if contentSize.height > 0 {
      let headers = layoutAttributes.flatMap({ $0 }).filter({ $0.representedElementKind == CollectionView.collectionViewHeaderType })
      if let maxHeader = (headers.max { $0.frame.height < $1.frame.height }) {
        let maxHeaderHeight = maxHeader.frame.height
        contentSize.height += maxHeaderHeight
      }
      let footers = layoutAttributes.flatMap({ $0 }).filter({ $0.representedElementKind == CollectionView.collectionViewFooterType })
      if let maxFooter = (footers.max { $0.frame.height < $1.frame.height }) {
        let maxFooterHeight = maxFooter.frame.height
        contentSize.height += maxFooterHeight
      }
    }

    self.contentSize = contentSize
    createCache(with: layoutAttributes)
    if stickyHeaders || stickyFooters {
      positionHeadersAndFooters()
    }
  }
}
