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

    var layoutAttributes = [[LayoutAttributes]]()
    var contentSize: CGSize = .zero
    var nextX: CGFloat = 0
    var widthOfSection: CGFloat = 0

    for section in 0..<numberOfSections {
      widthOfSection = 0
      guard numberOfItemsInSection(section) > 0 else {
        continue
      }

      var firstItem: LayoutAttributes? = nil
      var previousItem: LayoutAttributes? = nil
      var headerAttribute: SupplementaryLayoutAttributes? = nil
      var footerAttribute: SupplementaryLayoutAttributes? = nil
      let sectionIndexPath = IndexPath(item: 0, section: section)

      if headerReferenceSize.height > 0 {
        let layoutAttribute: SupplementaryLayoutAttributes = createSupplementaryLayoutAttribute(
          ofKind: .header,
          indexPath: sectionIndexPath,
          atX: nextX
        )
        layoutAttribute.min = nextX
        headerAttribute = layoutAttribute
        layoutAttributes.append([layoutAttribute])
      }

      for item in 0..<numberOfItemsInSection(section) {
        let indexPath = IndexPath(item: item, section: section)
        let layoutAttribute = LayoutAttributes.init(forCellWith: indexPath)

        defer { previousItem = layoutAttribute }

        layoutAttribute.size = resolveSizeForItem(at: indexPath)
        layoutAttribute.frame.origin.y = sectionInset.top + headerReferenceSize.height

        if item > 0, let previousItem = previousItem {
          layoutAttribute.frame.origin.x = previousItem.frame.maxX + minimumInteritemSpacing

          if itemsPerColumn > 1 && !(item % itemsPerColumn == 0) {
            layoutAttribute.frame.origin.x = previousItem.frame.origin.x
            layoutAttribute.frame.origin.y = previousItem.frame.maxY + minimumLineSpacing
          } else {
            widthOfSection += layoutAttribute.size.width + minimumInteritemSpacing
          }
        } else {
          firstItem = layoutAttribute
          contentSize.height = layoutAttribute.size.height

          if itemsPerColumn > 1 {
            contentSize.height += minimumLineSpacing
            contentSize.height *= CGFloat(itemsPerColumn)
            contentSize.height -= minimumLineSpacing
          }

          contentSize.height += sectionInset.top + sectionInset.bottom
          layoutAttribute.frame.origin.x = nextX + sectionInset.left
          widthOfSection += sectionInset.left + sectionInset.right + layoutAttribute.size.width
        }

        if section == layoutAttributes.count {
          layoutAttributes.append([layoutAttribute])
        } else {
          layoutAttributes[section].append(layoutAttribute)
        }
      }

      if let previousItem = previousItem, let firstItem = firstItem {
        contentSize.width = previousItem.frame.maxX + sectionInset.right

        if footerReferenceSize.height > 0 {
          let layoutAttribute = createSupplementaryLayoutAttribute(
            ofKind: .footer,
            indexPath: sectionIndexPath,
            atX: nextX
          )
          layoutAttribute.min = nextX
          layoutAttribute.frame.origin.y = contentSize.height + footerReferenceSize.height
          layoutAttributes[section].append(layoutAttribute)
          footerAttribute = layoutAttribute
        }

        if let collectionView = collectionView, let supplementaryWidth = supplementaryWidth {
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
      contentSize.height += headerReferenceSize.height + footerReferenceSize.height
    }

    self.contentSize = contentSize
    createCache(with: layoutAttributes)
    if stickyHeaders || stickyFooters {
      positionHeadersAndFooters()
    }
  }
}
