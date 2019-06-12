#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

@objc public class VerticalMosaicBlueprintLayout: BlueprintLayout {
  private let controller: MosaicBlueprintPatternController

  @objc public required init(
    patternHeight: CGFloat = 50,
    minimumInteritemSpacing: CGFloat = 10,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    stickyHeaders: Bool = true,
    stickyFooters: Bool = true,
    animator: BlueprintLayoutAnimator = DefaultLayoutAnimator(),
    patterns: [MosaicPattern]
    ) {
    self.controller = MosaicBlueprintPatternController(patterns: patterns)
    let itemsPerRow = CGFloat(patterns.count)
    super.init(
      itemsPerRow: itemsPerRow,
      itemSize: .init(width: 50, height: patternHeight),
      estimatedItemSize: .zero,
      minimumInteritemSpacing: minimumInteritemSpacing,
      minimumLineSpacing: minimumLineSpacing,
      sectionInset: sectionInset,
      stickyHeaders: stickyHeaders,
      stickyFooters: stickyFooters,
      animator: animator
    )
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func prepare() {
    guard prepareAllowed else {
        return
    }
    prepareAllowed = false

    super.prepare()

    var layoutAttributes = [[LayoutAttributes]]()
    var threshold: CGFloat = 0.0

    if let collectionViewWidth = collectionView?.documentRect.width {
      threshold = collectionViewWidth
    }

    var mosaicCount: Int = 0
    var nextY: CGFloat = 0

    for section in 0..<numberOfSections {
      guard numberOfItemsInSection(section) > 0 else { continue }

      var previousAttribute: MosaicLayoutAttributes?
      var headerAttribute: SupplementaryLayoutAttributes? = nil
      var footerAttribute: SupplementaryLayoutAttributes? = nil
      let sectionIndexPath = IndexPath(item: 0, section: section)

      if headerReferenceSize.height > 0 {
        let layoutAttribute = createSupplementaryLayoutAttribute(
          ofKind: .header,
          indexPath: sectionIndexPath,
          atY: nextY
        )
        layoutAttribute.min = nextY
        layoutAttribute.frame.size.width = collectionView?.documentRect.width ?? headerReferenceSize.width
        layoutAttributes.append([layoutAttribute])
        headerAttribute = layoutAttribute
        headerAttribute?.zIndex = numberOfSections
        nextY = layoutAttribute.frame.maxY
      }

      nextY += sectionInset.top
      var sectionMaxY: CGFloat = 0

      for item in 0..<numberOfItemsInSection(section) {
        let layoutAttribute: LayoutAttributes
        let indexPath = IndexPath(item: item, section: section)

        if let previousAttribute = previousAttribute, previousAttribute.remaining > 0 {
          let childLayoutAttribute = LayoutAttributes.init(forCellWith: indexPath)
          previousAttribute.childAttributes.append(childLayoutAttribute)
          previousAttribute.remaining -= 1
          process(previousAttribute, width: threshold)
          layoutAttribute = childLayoutAttribute
          sectionMaxY = max(previousAttribute.frame.maxY, layoutAttribute.frame.maxY)
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
            mosaicLayoutAttribute.frame.origin.y = nextY
          }

          previousAttribute = mosaicLayoutAttribute
          layoutAttribute = mosaicLayoutAttribute
          mosaicCount += 1
          sectionMaxY = layoutAttribute.frame.maxY
        }

        if section == layoutAttributes.count {
          layoutAttributes.append([layoutAttribute])
        } else {
          layoutAttributes[section].append(layoutAttribute)
        }
      }

      if let previousAttribute = previousAttribute {
        nextY = previousAttribute.frame.maxY
        if footerReferenceSize.height > 0 {
          let layoutAttribute = createSupplementaryLayoutAttribute(
            ofKind: .footer,
            indexPath: sectionIndexPath,
            atY: nextY + sectionInset.bottom
          )
          layoutAttribute.zIndex = numberOfSections
          layoutAttribute.min = headerAttribute?.frame.origin.y ?? nextY
          layoutAttributes[section].append(layoutAttribute)
          nextY = layoutAttribute.frame.maxY
          footerAttribute = layoutAttribute
        } else {
          nextY = nextY + sectionInset.bottom
        }

        headerAttribute?.max = sectionMaxY + sectionInset.bottom - footerReferenceSize.height
        footerAttribute?.max = sectionMaxY + sectionInset.bottom - footerReferenceSize.height

        contentSize.height = previousAttribute.frame.maxY + sectionInset.bottom + footerReferenceSize.height

      }
      headerAttribute = nil
      footerAttribute = nil
    }

    contentSize.width = threshold
    self.contentSize = contentSize
    createCache(with: layoutAttributes)
    if stickyHeaders || stickyFooters {
      positionHeadersAndFooters()
    }
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
