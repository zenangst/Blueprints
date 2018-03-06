#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

open class HorizontalFlowLayout: CoreFlowLayout {
  public var itemsPerColumn: Int

  required public init(
    itemsPerRow: CGFloat? = nil,
    itemsPerColumn: Int = 1,
    itemSize: CGSize = CGSize(width: 50, height: 50),
    minimumInteritemSpacing: CGFloat = 10,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    animator: CollectionViewFlowLayoutAnimator = DefaultAnimator()
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
    self.layoutAttributes = nil
    var layoutAttributes = [[Int: LayoutAttributes]]()
    var contentSize: CGSize = .zero

    for section in 0..<numberOfSections {
      var previousItem: LayoutAttributes? = nil

      for item in 0..<numberOfItemsInSection(section) {
        let indexPath = IndexPath(item: item, section: section)
        if let layoutAttribute = super.layoutAttributesForItem(at: indexPath)?.copy() as? LayoutAttributes {
          defer { previousItem = layoutAttribute }
          layoutAttribute.size = resolveSizeForItem(at: indexPath)

          layoutAttribute.frame.origin.y = sectionInset.top

          if item > 0, let previousItem = previousItem {
            layoutAttribute.frame.origin.x = previousItem.frame.maxX + minimumInteritemSpacing

            if itemsPerColumn > 1 && !(item % itemsPerColumn == 0) {
              layoutAttribute.frame.origin.x = previousItem.frame.origin.x
              layoutAttribute.frame.origin.y = previousItem.frame.maxY + minimumLineSpacing
            } else {
              contentSize.width += layoutAttribute.size.width + minimumInteritemSpacing
            }
          } else {
            contentSize.height = sectionInset.top + sectionInset.bottom + layoutAttribute.size.height

            if itemsPerColumn > 1 {
              contentSize.height *= CGFloat(itemsPerColumn)
            }

            layoutAttribute.frame.origin.x = sectionInset.left

            contentSize.width += sectionInset.left + sectionInset.right
            contentSize.width += layoutAttribute.size.width
          }

          if layoutAttributes.isEmpty {
            layoutAttributes.append([item: layoutAttribute])
          } else {
            layoutAttributes[section][item] = layoutAttribute
          }
        }
      }
      previousItem = nil
    }

    self.layoutAttributes = layoutAttributes
    self.contentSize = contentSize
  }
}
