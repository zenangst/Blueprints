#if os(macOS)
import Cocoa
#else
import UIKit
#endif

@objc public class VerticalWaterfallBlueprintLayout: BlueprintLayout {
  public override func prepare() {
    super.prepare()
    var layoutAttributes = self.cachedAttributes
    var threshold: CGFloat = 0.0

    if let collectionViewWidth = collectionView?.documentRect.width {
      threshold = collectionViewWidth
    }

    var nextY: CGFloat = 0
    var currentRow = 0
    var waterfallAttributes = [LayoutAttributes]()

    for section in 0..<numberOfSections {
      guard numberOfItemsInSection(section) > 0 else { continue }
      guard let itemsPerRow = itemsPerRow else { return }
      var previousAttribute: LayoutAttributes?
      nextY += sectionInset.top
      for item in 0..<numberOfItemsInSection(section) {
        let indexPath = IndexPath(item: item, section: section)
        let layoutAttribute: LayoutAttributes = .init(forCellWith: indexPath)

        defer {
          previousAttribute = layoutAttribute
          waterfallAttributes.append(layoutAttribute)
        }

        layoutAttribute.frame.size = resolveSizeForItem(at: indexPath)

        if indexPath.item % Int(itemsPerRow) == 0, indexPath.item > 0 {
          currentRow += 1
        }

        if let previousAttribute = previousAttribute {
          if currentRow > 0 {
            if let first = waterfallAttributes.sorted(by: { $0.frame.maxY <= $1.frame.maxY }).first {

              layoutAttribute.frame.origin.x = first.frame.origin.x
              layoutAttribute.frame.origin.y = first.frame.maxY + minimumLineSpacing

              if let index = waterfallAttributes.index(of: first) {
                waterfallAttributes.remove(at: index)
              }
            }
          } else {
            layoutAttribute.frame.origin.x = previousAttribute.frame.maxX + minimumInteritemSpacing
            layoutAttribute.frame.origin.y = nextY
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
    }

    if let lastAttribute = Array(layoutAttributes.joined()).sorted(by: { $0.frame.maxY > $1.frame.maxY }).first {
      let height = lastAttribute.frame.maxY
      contentSize.height = height + sectionInset.bottom
    } else {
      contentSize.height = 0
    }

    contentSize.width = threshold
    self.contentSize = contentSize
    createCache(with: layoutAttributes)
  }
}
