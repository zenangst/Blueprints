#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

open class CoreFlowLayout : CollectionViewFlowLayout {
  override open var collectionViewContentSize: CGSize { return contentSize }
  public var itemsPerRow: CGFloat?
  public var layoutAttributes: [[Int: LayoutAttributes]]?
  public var contentSize: CGSize = CGSize(width: 50, height: 50)
  var numberOfSections: Int { return resolveCollectionView({ $0.dataSource?.numberOfSections?(in: $0) },
                                                           defaultValue: 1) }
  var animator: CollectionViewFlowLayoutAnimator

  public init(
    itemsPerRow: CGFloat? = nil,
    itemSize: CGSize = CGSize(width: 50, height: 50),
    minimumInteritemSpacing: CGFloat = 10,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    animator: CollectionViewFlowLayoutAnimator = DefaultAnimator()
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

  override open func layoutAttributesForItem(at indexPath: IndexPath) -> LayoutAttributes? {
    if layoutAttributes == nil {
      let layoutAttribute = super.layoutAttributesForItem(at: indexPath)
      layoutAttribute?.frame.size = resolveSizeForItem(at: indexPath)
      return layoutAttribute
    }

    return layoutAttributes?[indexPath.section][indexPath.item] ?? nil
  }

  override open func layoutAttributesForElements(in rect: CGRect) -> LayoutAttributesForElements {
    let result = layoutAttributes?.flatMap({ $0.values }).filter({ $0.frame.intersects(rect) }) ?? []
    return result
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
    var spanWidth = containerWidth - sectionInset.left - sectionInset.right

    if itemsPerRow > 1 {
      spanWidth -= minimumInteritemSpacing * (itemsPerRow - 1)
    }

    return floor(spanWidth / itemsPerRow)
  }

  func resolveSizeForItem(at indexPath: IndexPath) -> CGSize {
    if let collectionView = collectionView, let span = itemsPerRow, span > 0 {
      let containerWidth: CGFloat
      #if os(macOS)
        containerWidth = collectionView.enclosingScrollView?.frame.width ?? 0
      #else
        containerWidth = collectionView.frame.size.width
      #endif

      let size = CGSize(
        width: calculateItemWidth(span, containerWidth: containerWidth),
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
