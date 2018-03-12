#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

open class VerticalBlueprintLayout: BlueprintLayout {
  public var stickyHeaders: Bool = false
  public var stickyFooters: Bool = false

  required public override init(
    itemsPerRow: CGFloat? = nil,
    itemSize: CGSize = CGSize(width: 50, height: 50),
    minimumInteritemSpacing: CGFloat = 0,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    animator: BlueprintLayoutAnimator = DefaultLayoutAnimator()
    ) {
    super.init(
      itemsPerRow: itemsPerRow,
      itemSize: itemSize,
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
    var layoutAttributes = self.layoutAttributes
    var threshold: CGFloat = 0.0

    if let collectionViewWidth = collectionView?.frame.size.width {
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
        layoutAttribute.frame.size.width = collectionView?.frame.size.width ?? headerReferenceSize.width
        layoutAttributes.append([layoutAttribute])
        headerAttribute = layoutAttribute
        nextY = layoutAttribute.frame.maxY
      }

      nextY += sectionInset.top

      for item in 0..<numberOfItemsInSection(section) {
        let indexPath = IndexPath(item: item, section: section)
        let layoutAttribute = LayoutAttributes.init(forCellWith: indexPath)

        defer { previousItem = layoutAttribute }

        layoutAttribute.size = resolveSizeForItem(at: indexPath)

        if let previousItem = previousItem {
          layoutAttribute.frame.origin.x = previousItem.frame.maxX + minimumInteritemSpacing
          layoutAttribute.frame.origin.y = previousItem.frame.origin.y

          if layoutAttribute.frame.maxX > threshold {
            layoutAttribute.frame.origin.x = sectionInset.left
            layoutAttribute.frame.origin.y = previousItem.frame.maxY + minimumLineSpacing
          }
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
            atY: nextY + sectionInset.bottom
          )
          layoutAttributes[section].append(layoutAttribute)
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

          let headerFooterY = min(
            max(collectionView.contentOffset.y + contentInsetTop, firstItem.frame.origin.y - headerReferenceSize.height - sectionInset.top),
            previousItem.frame.maxY - headerReferenceSize.height + sectionInset.bottom
          )

          if stickyHeaders {
            headerAttribute?.frame.origin.y = headerFooterY
            headerAttribute?.frame.size.width = headerFooterWidth
          }

          if stickyFooters {
            footerAttribute?.frame.origin.y = headerFooterY
            footerAttribute?.frame.size.width = headerFooterWidth
          }
        }

        contentSize.height = previousItem.frame.maxY - headerReferenceSize.height + sectionInset.bottom
      }

      previousItem = nil
      headerAttribute = nil
      footerAttribute = nil
      firstItem = nil
    }

    contentSize.width = collectionView?.frame.width ?? 0
    contentSize.height += headerReferenceSize.height + footerReferenceSize.height

    self.layoutAttributes = layoutAttributes
    self.contentSize = contentSize
  }
}
