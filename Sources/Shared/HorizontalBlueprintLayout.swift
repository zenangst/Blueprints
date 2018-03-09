#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

open class HorizontalBlueprintLayout: BlueprintLayout {
  public var itemsPerColumn: Int

  required public init(
    itemsPerRow: CGFloat? = nil,
    itemsPerColumn: Int = 1,
    itemSize: CGSize = CGSize(width: 50, height: 50),
    minimumInteritemSpacing: CGFloat = 10,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    animator: BlueprintLayoutAnimator = DefaultLayoutAnimator()
    ) {
    self.itemsPerColumn = itemsPerColumn
    super.init(
      itemsPerRow: itemsPerRow,
      itemSize: itemSize,
      minimumInteritemSpacing: minimumInteritemSpacing,
      minimumLineSpacing: minimumLineSpacing,
      sectionInset: sectionInset,
      animator: animator
    )
    self.scrollDirection = .horizontal
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func prepare() {
    super.prepare()
    var layoutAttributes = self.layoutAttributes
    var contentSize: CGSize = .zero
    var nextX: CGFloat = 0
    var widthOfSection: CGFloat = 0

    for section in 0..<numberOfSections {
      widthOfSection = 0
      guard numberOfItemsInSection(section) > 0 else {
        continue
      }

      var previousItem: LayoutAttributes? = nil
      var headerAttribute: LayoutAttributes? = nil
      let sectionIndexPath = IndexPath(item: 0, section: section)

      for item in 0..<numberOfItemsInSection(section) {
        if headerReferenceSize.height > 0 {
          let layoutAttribute = createHeader(sectionIndexPath, atX: nextX)
          headerAttribute = layoutAttribute
          layoutAttributes.append([layoutAttribute])
        }

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
          contentSize.height = sectionInset.top + sectionInset.bottom + layoutAttribute.size.height

          if itemsPerColumn > 1 {
            contentSize.height *= CGFloat(itemsPerColumn)
            contentSize.height -= minimumLineSpacing
          }

          layoutAttribute.frame.origin.x = nextX + sectionInset.left
          widthOfSection += sectionInset.left + sectionInset.right + layoutAttribute.size.width
        }

        if section == layoutAttributes.count {
          layoutAttributes.append([layoutAttribute])
        } else {
          layoutAttributes[section].append(layoutAttribute)
        }
      }

      if let previousItem = previousItem {
        contentSize.width = previousItem.frame.maxX + sectionInset.right
        headerAttribute?.frame.size.width = widthOfSection

        if footerReferenceSize.height > 0 {
          let layoutAttribute = createFooter(sectionIndexPath, atX: nextX)
          layoutAttribute.frame.size.width = widthOfSection
          layoutAttribute.frame.origin.y = contentSize.height + footerReferenceSize.height
          layoutAttributes[section].append(layoutAttribute)
        }

        nextX += widthOfSection
      }

      previousItem = nil
    }

    contentSize.height += headerReferenceSize.height + footerReferenceSize.height

    self.layoutAttributes = layoutAttributes
    self.contentSize = contentSize
  }
}
