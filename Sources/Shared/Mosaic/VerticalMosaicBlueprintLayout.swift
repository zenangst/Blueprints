#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

@objc public class VerticalMosaicBlueprintLayout: BlueprintLayout {
  private let controller: MosaicBlueprintPatternController

  @objc public required init(
    itemSize: CGSize = CGSize(width: 50, height: 50),
    estimatedItemSize: CGSize = .zero,
    minimumInteritemSpacing: CGFloat = 10,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    animator: BlueprintLayoutAnimator = DefaultLayoutAnimator(),
    patterns: [MosaicPattern]
    ) {
    self.controller = MosaicBlueprintPatternController(patterns: patterns)
    super.init(
      itemsPerRow: 0.0,
      itemSize: itemSize,
      estimatedItemSize: estimatedItemSize,
      minimumInteritemSpacing: minimumInteritemSpacing,
      minimumLineSpacing: minimumLineSpacing,
      sectionInset: sectionInset,
      animator: animator
    )
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func prepare() {
    super.prepare()
    var layoutAttributes = self.cachedAttributes
    var threshold: CGFloat = 0.0

    if let collectionViewWidth = collectionView?.documentRect.width {
      threshold = collectionViewWidth
    }

    var mosaicCount: Int = 0

    for section in 0..<numberOfSections {
      guard numberOfItemsInSection(section) > 0 else { continue }

      var previousAttribute: MosaicLayoutAttributes?
      for item in 0..<numberOfItemsInSection(section) {
        let layoutAttribute: LayoutAttributes
        let indexPath = IndexPath(item: item, section: section)

        if let previousAttribute = previousAttribute, previousAttribute.remaining > 0 {
          let childLayoutAttribute = LayoutAttributes.init(forCellWith: indexPath)
          previousAttribute.childAttributes.append(childLayoutAttribute)
          previousAttribute.remaining -= 1
          process(previousAttribute, width: threshold)
          layoutAttribute = childLayoutAttribute
        } else {
          let layoutIndexPath = IndexPath(item: mosaicCount, section: section)
          let pattern = controller.values(at: layoutIndexPath)
          let mosaicLayoutAttribute = MosaicLayoutAttributes.init(indexPath, pattern: pattern)

          mosaicLayoutAttribute.frame.size.width = (threshold * pattern.multiplier) - minimumInteritemSpacing

          if mosaicLayoutAttribute.pattern.multiplier == 1 {
            mosaicLayoutAttribute.frame.size.width -= minimumInteritemSpacing
          }

          if mosaicLayoutAttribute.pattern.amount == 0 {
            mosaicLayoutAttribute.frame.size.width = threshold - sectionInset.left - sectionInset.right
          } else {
            mosaicLayoutAttribute.frame.size.width = (threshold - minimumInteritemSpacing - sectionInset.left - sectionInset.right) * CGFloat(mosaicLayoutAttribute.pattern.multiplier)
          }

          mosaicLayoutAttribute.frame.size.height = (itemSize.height * pattern.multiplier) - minimumLineSpacing

          apply(pattern, to: mosaicLayoutAttribute, with: threshold)

          if let previousAttribute = previousAttribute {
            mosaicLayoutAttribute.frame.origin.y = previousAttribute.frame.maxY + minimumLineSpacing
          } else {
            mosaicLayoutAttribute.frame.origin.y = sectionInset.top
          }

          previousAttribute = mosaicLayoutAttribute
          layoutAttribute = mosaicLayoutAttribute
          mosaicCount += 1
        }

        if section == layoutAttributes.count {
          layoutAttributes.append([layoutAttribute])
        } else {
          layoutAttributes[section].append(layoutAttribute)
        }
      }

      if let previousAttribute = previousAttribute {
        contentSize.height = previousAttribute.frame.maxY + sectionInset.bottom
      }
    }

    contentSize.width = threshold
    self.contentSize = contentSize
    createCache(with: layoutAttributes)
  }

  private func apply(_ pattern: MosaicPattern, to mosaicLayoutAttribute: MosaicLayoutAttributes, with threshold: CGFloat) {
    switch pattern.alignment {
    case .left:
      mosaicLayoutAttribute.frame.origin.x = sectionInset.left
    case .right:
      mosaicLayoutAttribute.frame.origin.x = threshold - mosaicLayoutAttribute.frame.size.width - sectionInset.right
    }
  }

  private func process(_ mosaic: MosaicLayoutAttributes, width: CGFloat) {
    let childCount = CGFloat(mosaic.childAttributes.count)
    for (offset, layoutAttribute) in mosaic.childAttributes.enumerated() {
      switch mosaic.pattern.alignment {
      case .left:
        layoutAttribute.frame.origin.x = mosaic.frame.maxX + minimumInteritemSpacing
      case .right:
        layoutAttribute.frame.origin.x = sectionInset.left
      }

      switch mosaic.pattern.direction {
      case .horizontal:
        layoutAttribute.frame.origin.y = mosaic.frame.origin.y

        switch mosaic.pattern.alignment {
        case .left:
          layoutAttribute.frame.size.width = (width - mosaic.frame.maxX - (minimumInteritemSpacing * childCount) - sectionInset.left) / childCount
        case .right:
          layoutAttribute.frame.size.width = (width - mosaic.frame.size.width - (minimumInteritemSpacing * childCount) - sectionInset.left - sectionInset.right) / childCount
        }

        layoutAttribute.frame.size.height = mosaic.frame.size.height

        if childCount == 1 {
          layoutAttribute.frame.size.width += minimumInteritemSpacing
        }

        if offset > 0 {
          layoutAttribute.frame.origin.x += (layoutAttribute.frame.size.width + minimumLineSpacing) * CGFloat(offset)
        }
      case .vertical:
        layoutAttribute.frame.origin.y = mosaic.frame.origin.y

        switch mosaic.pattern.alignment {
        case .left:
          layoutAttribute.frame.size.width = width - mosaic.frame.maxX - minimumInteritemSpacing - sectionInset.right
        case .right:
          layoutAttribute.frame.size.width = width - mosaic.frame.size.width - minimumInteritemSpacing - sectionInset.left - sectionInset.right
        }

        layoutAttribute.frame.size.height = (mosaic.frame.size.height - minimumLineSpacing) / childCount

        if childCount > 1 {
          layoutAttribute.frame.size.height = floor(mosaic.frame.size.height / childCount) - round(minimumLineSpacing / childCount)
        } else if childCount == 1 {
          layoutAttribute.frame.size.height = mosaic.frame.size.height
        }

        if offset > 0 {
          layoutAttribute.frame.origin.y += (layoutAttribute.frame.size.height + minimumLineSpacing) * CGFloat(offset)
        }
      }
    }
  }
}
