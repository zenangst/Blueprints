#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

open class VerticalBlueprintLayout: BlueprintLayout {
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

      var previousItem: LayoutAttributes? = nil
      let sectionIndexPath = IndexPath(item: 0, section: section)

      if headerReferenceSize.height > 0 {
        let layoutAttribute = createHeader(sectionIndexPath, atY: nextY)
        layoutAttribute.frame.size.width = collectionView?.frame.size.width ?? headerReferenceSize.width
        layoutAttributes.append([layoutAttribute])
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
          layoutAttribute.frame.origin.x = sectionInset.left
          layoutAttribute.frame.origin.y = nextY
        }

        if section == layoutAttributes.count {
          layoutAttributes.append([layoutAttribute])
        } else {
          layoutAttributes[section].append(layoutAttribute)
        }
      }

      if let previousItem = previousItem {
        nextY = previousItem.frame.maxY
        if footerReferenceSize.height > 0 {
          let layoutAttribute = createFooter(sectionIndexPath, atY: nextY)
          layoutAttribute.frame.size.width = collectionView?.frame.size.width ?? footerReferenceSize.width
          layoutAttributes[section].append(layoutAttribute)
          nextY = layoutAttribute.frame.maxY
        }

        contentSize.height = previousItem.frame.maxY - headerReferenceSize.height + sectionInset.bottom
      }

      previousItem = nil
    }

    contentSize.width = collectionView?.frame.width ?? 0
    contentSize.height += headerReferenceSize.height + footerReferenceSize.height

    self.layoutAttributes = layoutAttributes
    self.contentSize = contentSize
  }
}
