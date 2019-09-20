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

    let sections = numberOfSections
    var layoutAttributes = Array<[LayoutAttributes]>.init(repeating: [LayoutAttributes](),
                                                          count: sections)
    var threshold: CGFloat = collectionViewWidth
    var nextY: CGFloat = 0

    for section in 0..<sections {
      let numberOfItems = numberOfItemsInSection(section)
      guard numberOfItems > 0 else {
        continue
      }
      var previousAttribute: LayoutAttributes? = nil
      var headerAttribute: SupplementaryLayoutAttributes? = nil
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
        layoutAttribute.min = nextY
        layoutAttribute.frame.origin.x = 0
        layoutAttribute.frame.origin.y = nextY
        layoutAttributes[section].append(layoutAttribute)
        headerAttribute = layoutAttribute
        nextY = layoutAttribute.frame.maxY
      }

      nextY += sectionInset.top
      var sectionMaxY: CGFloat = 0
      let perRow = Int(itemsPerRow ?? 1)

      for item in 0..<numberOfItems {
        let indexPath = IndexPath(item: item, section: section)
        let layoutAttribute = LayoutAttributes(forCellWith: indexPath)

        defer { previousAttribute = layoutAttribute }

        layoutAttribute.size = resolveSizeForItem(at: indexPath)

        if let previousItem = previousAttribute {
          if perRow > 1,
            perRow > perRow - 1,
            perRow - 1 < layoutAttributes[section].count {
            let lookupAttributes = layoutAttributes[section].filter({ $0.representedElementCategory == .cellItem })
            var minimumYAttributes = lookupAttributes.sorted(by: { $0.frame.maxY < $1.frame.maxY })

            if lookupAttributes.count < perRow {
              layoutAttribute.frame.origin.x = previousItem.frame.maxX + sectionsMinimumInteritemSpacing
              layoutAttribute.frame.origin.y = previousItem.frame.minY
            } else if !lookupAttributes.isEmpty,
              let minimumYAttribute = lookupAttributes.filter({ $0.frame.maxY == minimumYAttributes.first!.frame.maxY }).first {
              layoutAttribute.frame.origin.x = minimumYAttribute.frame.minX
              layoutAttribute.frame.origin.y = minimumYAttribute.frame.maxY + sectionsMinimumLineSpacing
              while minimumYAttributes.contains(where: { $0.frame.minY == layoutAttribute.frame.minY && $0.frame.minX == layoutAttribute.frame.minX }) {
                guard let minimumYAttribute = minimumYAttributes.first else {
                  break
                }
                minimumYAttributes.removeFirst()
                layoutAttribute.frame.origin.x = minimumYAttribute.frame.minX
                layoutAttribute.frame.origin.y = minimumYAttribute.frame.maxY + sectionsMinimumLineSpacing
              }
            }
          } else {
            layoutAttribute.frame.origin.x = previousItem.frame.maxX + sectionsMinimumInteritemSpacing
            layoutAttribute.frame.origin.y = previousItem.frame.minY
          }
          if layoutAttribute.frame.maxX > threshold {
            layoutAttribute.frame.origin.x = sectionInset.left
            layoutAttribute.frame.origin.y = previousItem.frame.maxY + sectionsMinimumLineSpacing
          }
          sectionMaxY = max(sectionMaxY, layoutAttribute.frame.maxY)
        } else {
          layoutAttribute.frame.origin.x = sectionInset.left
          layoutAttribute.frame.origin.y = nextY
          sectionMaxY = layoutAttribute.frame.maxY
        }

        layoutAttributes[section].append(layoutAttribute)
      }

      headerAttribute?.max = sectionMaxY + sectionInset.bottom - headerSize.height

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
          layoutAttribute.zIndex = section + numberOfItems
          layoutAttribute.min = headerAttribute?.frame.maxY ?? previousY
          layoutAttribute.max = sectionMaxY + sectionInset.bottom
          layoutAttribute.frame.origin.x = 0
          layoutAttribute.frame.origin.y = sectionMaxY + sectionInset.bottom
          layoutAttributes[section].append(layoutAttribute)
          nextY = layoutAttribute.frame.maxY
        } else {
          nextY = sectionMaxY + sectionInset.bottom
        }
        contentSize.height = sectionMaxY - headerSize.height + sectionInset.bottom
        headerAttribute?.max = contentSize.height
      }
      previousAttribute = nil
      headerAttribute = nil
    }

    let indexOffset = 1
    let lastHeaderReferenceHeight = resolveSizeForSupplementaryView(ofKind: .header, at: IndexPath(item: 0, section: numberOfSections - indexOffset)).height
    let lastFooterReferenceHeight: CGFloat
    if numberOfSections < 0 {
      lastFooterReferenceHeight = resolveSizeForSupplementaryView(ofKind: .footer, at: IndexPath(item: numberOfItemsInSection(numberOfSections - indexOffset), section: numberOfSections - indexOffset)).height
    } else {
      lastFooterReferenceHeight = footerReferenceSize.height
    }

    contentSize.height += lastHeaderReferenceHeight + lastFooterReferenceHeight
    contentSize.width = threshold

    self.contentSize = contentSize
    createCache(with: layoutAttributes)
    if stickyHeaders || stickyFooters {
      positionHeadersAndFooters()
    }
  }
}
