#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

open class VerticalFlowLayout: CoreFlowLayout {
  required public override init(
    itemsPerRow: CGFloat? = nil,
    itemSize: CGSize = CGSize(width: 50, height: 50),
    minimumInteritemSpacing: CGFloat = 0,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    animator: CollectionViewFlowLayoutAnimator = DefaultAnimator()
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
    self.contentSize = .zero
    self.layoutAttributes = nil
    var layoutAttributes = [[Int: LayoutAttributes]]()
    var threshold: CGFloat = 0.0

    if let collectionViewWidth = collectionView?.frame.size.width {
      threshold = collectionViewWidth
    }

    for section in 0..<numberOfSections {
      var previousItem: LayoutAttributes? = nil
      for item in 0..<numberOfItemsInSection(section) {
        let indexPath = IndexPath(item: item, section: section)
        if let layoutAttribute = super.layoutAttributesForItem(at: IndexPath(item: item, section: section))?.copy() as? LayoutAttributes {
          defer { previousItem = layoutAttribute }

          layoutAttribute.size = resolveSizeForItem(at: indexPath)

          if let previousItem = previousItem {
            layoutAttribute.frame.origin.x = previousItem.frame.maxX + minimumInteritemSpacing
            layoutAttribute.frame.origin.y = previousItem.frame.origin.y

            if layoutAttribute.frame.maxX > threshold {
              layoutAttribute.frame.origin.x = sectionInset.left
              layoutAttribute.frame.origin.y = previousItem.frame.maxY + minimumLineSpacing
              contentSize.height += layoutAttribute.size.height + minimumLineSpacing
            }
          } else {
            layoutAttribute.frame.origin.x = sectionInset.left
            layoutAttribute.frame.origin.y = sectionInset.top
            contentSize.height += layoutAttribute.size.height
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

    contentSize.width = collectionView?.frame.width ?? 0
    contentSize.height += sectionInset.top + sectionInset.bottom

    self.layoutAttributes = layoutAttributes
    self.contentSize = contentSize
  }
}
