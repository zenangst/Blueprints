#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

open class BlueprintLayout : CollectionViewFlowLayout {
  override open var collectionViewContentSize: CGSize { return contentSize }
  public var itemsPerRow: CGFloat?
  public var layoutAttributes = [[LayoutAttributes]]()
  public var contentSize: CGSize = CGSize(width: 50, height: 50)
  var numberOfSections: Int { return resolveCollectionView({ $0.dataSource?.numberOfSections?(in: $0) },
                                                           defaultValue: 1) }
  var animator: BlueprintLayoutAnimator

  public init(
    itemsPerRow: CGFloat? = nil,
    itemSize: CGSize = CGSize(width: 50, height: 50),
    minimumInteritemSpacing: CGFloat = 10,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    animator: BlueprintLayoutAnimator = DefaultLayoutAnimator()
    ) {
    self.itemsPerRow = itemsPerRow
    self.animator = animator
    super.init()
    self.itemSize = itemSize
    self.minimumInteritemSpacing = minimumInteritemSpacing
    self.minimumLineSpacing = minimumLineSpacing
    self.sectionInset = sectionInset
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }



  open override func prepare() {
    self.contentSize = .zero
    self.layoutAttributes = []
  }

  func createHeader(_ indexPath: IndexPath, atX x: CGFloat = 0, atY y: CGFloat = 0) -> LayoutAttributes {
    let layoutAttribute = LayoutAttributes(
      forSupplementaryViewOfKind: CollectionView.collectionViewHeaderType,
      with: indexPath
    )
    layoutAttribute.zIndex = indexPath.section
    layoutAttribute.size.height = headerReferenceSize.height
    layoutAttribute.frame.origin.x = x
    layoutAttribute.frame.origin.y = y

    return layoutAttribute
  }

  func createFooter(_ indexPath: IndexPath, atX x: CGFloat = 0, atY y: CGFloat = 0) -> LayoutAttributes {
    let layoutAttribute = LayoutAttributes(
      forSupplementaryViewOfKind: CollectionView.collectionViewFooterType,
      with: indexPath
    )
    layoutAttribute.zIndex = indexPath.section
    layoutAttribute.size.height = footerReferenceSize.height
    layoutAttribute.frame.origin.x = x
    layoutAttribute.frame.origin.y = y + sectionInset.bottom

    return layoutAttribute
  }

  override open func layoutAttributesForItem(at indexPath: IndexPath) -> LayoutAttributes? {
    guard indexPath.section < layoutAttributes.count else {
      return nil
    }

    guard indexPath.item < layoutAttributes[indexPath.section].count else {
      return nil
    }

    return layoutAttributes[indexPath.section][indexPath.item]
  }

  override open func layoutAttributesForElements(in rect: CGRect) -> LayoutAttributesForElements {
    return layoutAttributes.flatMap { $0 }.filter { $0.frame.intersects(rect) }
  }

  override open func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> LayoutAttributes? {
    guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else {
      return nil
    }

    return animator.initialLayoutAttributesForAppearingItem(at: itemIndexPath,
                                                            with: attributes)
  }

  override open func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> LayoutAttributes? {
    guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else {
      return nil
    }

    return animator.finalLayoutAttributesForDisappearingItem(at: itemIndexPath,
                                                             with: attributes)
  }

  override open func prepare(forCollectionViewUpdates updateItems: [CollectionViewUpdateItem]) {
    return animator.prepare(forCollectionViewUpdates: updateItems)
  }

  // MARK: - Internal methods

  func numberOfItemsInSection(_ section: Int) -> Int {
    return resolveCollectionView({ collectionView in
      collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section)
    }, defaultValue: 0)
  }

  func calculateItemWidth(_ itemsPerRow: CGFloat, containerWidth: CGFloat) -> CGFloat {
    var width = containerWidth - sectionInset.left - sectionInset.right

    if itemsPerRow > 1 {
      width -= minimumInteritemSpacing * (itemsPerRow - 1)
    }

    return floor(width / itemsPerRow)
  }

  func resolveSizeForItem(at indexPath: IndexPath) -> CGSize {
    if let collectionView = collectionView, let itemsPerRow = itemsPerRow, itemsPerRow > 0 {
      let containerWidth: CGFloat
      #if os(macOS)
        containerWidth = collectionView.enclosingScrollView?.frame.width ?? collectionView.frame.size.width
      #else
        containerWidth = collectionView.frame.size.width
      #endif

      let size = CGSize(
        width: calculateItemWidth(itemsPerRow, containerWidth: containerWidth),
        height: itemSize.height
      )

      return size
    } else {
      let size = resolveCollectionView({ collectionView -> CGSize? in
        return (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(collectionView,
                                                                                               layout: self,
                                                                                               sizeForItemAt: indexPath)
      }, defaultValue: itemSize)

      return size
    }
  }

  // MARK: - Private methods

  private func resolveCollectionView<T>(_ closure: (CollectionView) -> T?, defaultValue: T) -> T {
    if let collectionView = collectionView {
      return closure(collectionView) ?? defaultValue
    } else {
      return defaultValue
    }
  }
}
