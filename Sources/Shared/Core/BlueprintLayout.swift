#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

/// A concrete layout object that is a subclass of collection view flow layout.
/// This class is meant to be subclasses and not used directly.
/// When subclassing, your subclass should implement `prepare` with the
/// layout algorithm that your subclass should implement.
@objc open class BlueprintLayout : CollectionViewFlowLayout {
  override open var collectionViewContentSize: CGSize { return contentSize }
  /// The amount of items that should appear on each row.
  public var itemsPerRow: CGFloat?
  /// A layout attributes cache, gets invalidated with the collection view and filled using the `prepare` method.
  public var cachedAttributes = [[LayoutAttributes]]()
  public var cachedItems = [[LayoutAttributes]]()
  public var allCachedAttributes = [LayoutAttributes]()
  var binarySearch = BinarySearch()

  /// The content size of the layout, should be set using the `prepare` method of any subclass.
  public var contentSize: CGSize = CGSize(width: 50, height: 50)
  /// The number of sections in the collection view.
  var numberOfSections: Int { return resolveCollectionView({ $0.dataSource?.numberOfSections?(in: $0) },
                                                           defaultValue: 1) }
  /// A layout animator object, defaults to `DefaultLayoutAnimator`.
  var animator: BlueprintLayoutAnimator
  var headerFooterWidth: CGFloat?

  /// An initialized collection view layout object.
  ///
  /// - Parameters:
  ///   - itemsPerRow: The amount of items that should appear on each row.
  ///   - itemSize: The default size to use for cells.
  ///   - minimumInteritemSpacing: The minimum spacing to use between items in the same row.
  ///   - minimumLineSpacing: The minimum spacing to use between lines of items in the grid.
  ///   - sectionInset: The margins used to lay out content in a section
  ///   - animator: The animator that should be used for the layout, defaults to `DefaultLayoutAnimator`.
  @objc public init(
    itemsPerRow: CGFloat = 0.0,
    itemSize: CGSize = CGSize(width: 50, height: 50),
    estimatedItemSize: CGSize = .zero,
    minimumInteritemSpacing: CGFloat = 10,
    minimumLineSpacing: CGFloat = 10,
    sectionInset: EdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    animator: BlueprintLayoutAnimator = DefaultLayoutAnimator()
    ) {
    self.itemsPerRow = itemsPerRow
    self.animator = animator
    super.init()
    self.itemSize = itemSize
    self.estimatedItemSize = estimatedItemSize
    self.minimumInteritemSpacing = minimumInteritemSpacing
    self.minimumLineSpacing = minimumLineSpacing
    self.sectionInset = sectionInset

    #if os(macOS)
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(contentViewBoundsDidChange(_:)),
        name: NSView.boundsDidChangeNotification,
        object: nil
      )
    #endif
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - Internal methods

  /// Queries the data source for the amount of items inside of a section.
  ///
  /// - Parameter section: The section index.
  /// - Returns: The amount items inside of the section.
  func numberOfItemsInSection(_ section: Int) -> Int {
    return resolveCollectionView({ collectionView in
      collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section)
    }, defaultValue: 0)
  }

  /// Calculate width of item based of `itemsPerRow`.
  ///
  /// - Parameters:
  ///   - itemsPerRow: The amount of items that should appear per row.
  ///   - containerWidth: The container width used to calculate the width.
  /// - Returns: The desired width for the item.
  func calculateItemWidth(_ itemsPerRow: CGFloat, containerWidth: CGFloat) -> CGFloat {
    var width = containerWidth - sectionInset.left - sectionInset.right

    if itemsPerRow > 1 {
      width -= minimumInteritemSpacing * (itemsPerRow - 1)
    }

    return floor(width / itemsPerRow)
  }

  /// Resolve the size of item at index path.
  /// If the layout uses `itemsPerRow`, it will compute the size based of the amount of items that
  /// should appear per row using the size of the collection view.
  /// If the collection view's delegate conforms to `(UI/NS)CollectionViewDelegateFlowLayout`, it will
  /// query the delegate for the size of the item.
  /// It defaults to using the `itemSize` property on collection view flow layout.
  ///
  /// - Parameter indexPath: The index path of the item.
  /// - Returns: The desired size of the item at the index path.
  func resolveSizeForItem(at indexPath: IndexPath) -> CGSize {
    if let collectionView = collectionView, let itemsPerRow = itemsPerRow, itemsPerRow > 0 {
      let containerWidth: CGFloat
      #if os(macOS)
        containerWidth = collectionView.enclosingScrollView?.frame.width ?? collectionView.frame.size.width
      #else
        containerWidth = collectionView.frame.size.width
      #endif

      let height = resolveCollectionView({ collectionView -> CGSize? in
        return (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(collectionView,
                                                                                               layout: self,
                                                                                               sizeForItemAt: indexPath)
      }, defaultValue: itemSize).height

      let size = CGSize(
        width: calculateItemWidth(itemsPerRow, containerWidth: containerWidth),
        height: height
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

  /// Create supplementary layout attributes.
  ///
  /// - Parameters:
  ///   - kind: The supplementary kind, either header or footer.
  ///   - indexPath: The section index path for the supplementary view.
  ///   - x: The x coordinate of the header layout attributes.
  ///   - y: The y coordinate of the header layout attributes.
  /// - Returns: A `LayoutAttributes` object of supplementary kind.
  func createSupplementaryLayoutAttribute(ofKind kind: BlueprintSupplementaryKind, indexPath: IndexPath, atX x: CGFloat = 0, atY y: CGFloat = 0) -> LayoutAttributes {
    let layoutAttribute = LayoutAttributes(
      forSupplementaryViewOfKind: kind.collectionViewSupplementaryType,
      with: indexPath
    )

    switch kind {
    case .header:
      layoutAttribute.size.width = collectionView?.documentRect.width ?? headerReferenceSize.width
      layoutAttribute.size.height = headerReferenceSize.height
    case .footer:
      layoutAttribute.size.width = collectionView?.documentRect.width ?? footerReferenceSize.width
      layoutAttribute.size.height = footerReferenceSize.height
    }

    layoutAttribute.zIndex = indexPath.section
    layoutAttribute.frame.origin.x = x
    layoutAttribute.frame.origin.y = y

    return layoutAttribute
  }

  /// Resolve collection collection view from layout and return
  /// property or default value if collection view cannot be resolved.
  ///
  /// - Parameters:
  ///   - closure: A closure that takes a collectino view resolved from
  ///              the layout.
  ///   - defaultValue: A default value if the collection view cannot be
  ///                   resolved, it also infers type.
  /// - Returns: A property from the closure or the default value if the
  ///            closure returns `nil`.
  func resolveCollectionView<T>(_ closure: (CollectionView) -> T?, defaultValue: T) -> T {
    if let collectionView = collectionView {
      return closure(collectionView) ?? defaultValue
    } else {
      return defaultValue
    }
  }

  // MARK: - Overrides

  /// Tells the layout object to update the current layout.
  open override func prepare() {
    self.contentSize = .zero
    self.cachedAttributes = []
    self.cachedItems = []
    self.allCachedAttributes = []

    #if os(macOS)
      if let clipView = collectionView?.enclosingScrollView?.contentView {
        configureHeaderFooterWidth(clipView)
      }
    #endif
  }

  /// Create caches from the layout attributes produced by the layout algoritm.
  /// This method is invoked in the `prepare` method for the collection view layout.
  ///
  /// - Parameter attributes: The attributes that were created in the collection view layout.
  func createCache(with attributes: [[LayoutAttributes]]) {
    for value in attributes {
      #if os(macOS)
        var sorted = value.sorted(by: { $0.indexPath! < $1.indexPath! })
        self.cachedAttributes.append(sorted)
        sorted = sorted.filter({ $0.representedElementCategory == .item })
      #else
        var sorted = value.sorted(by: { $0.indexPath < $1.indexPath })
        self.cachedAttributes.append(sorted)
        sorted = sorted.filter({ $0.representedElementCategory == .cell })
      #endif
      self.cachedItems.append(sorted)
    }

    self.allCachedAttributes = Array(attributes.joined())

    switch scrollDirection {
    case .horizontal:
      self.allCachedAttributes = allCachedAttributes.sorted(by: { $0.frame.minX < $1.frame.minX })
    case .vertical:
      self.allCachedAttributes = allCachedAttributes.sorted(by: { $0.frame.minY < $1.frame.minY })
    }
  }

  open override func prepareForTransition(to newLayout: CollectionViewLayout) {
    super.prepareForTransition(to: newLayout)
    newLayout.prepare()
    if let superview = newLayout.collectionView?.superview {
      newLayout.collectionView?.frame.size.width = superview.frame.size.width
    } else {
      newLayout.collectionView?.frame.size.width = newLayout.collectionViewContentSize.width
    }
    newLayout.collectionView?.frame.size.height = newLayout.collectionViewContentSize.height
  }

  /// Returns the layout attributes for the item at the specified index path.
  ///
  /// - Parameter indexPath: The index path of the item whose attributes are requested.
  /// - Returns: A layout attributes object containing the information to apply to the item’s cell.
  override open func layoutAttributesForItem(at indexPath: IndexPath) -> LayoutAttributes? {
    let compare: (LayoutAttributes) -> Bool
    #if os(macOS)
      compare = { indexPath > $0.indexPath! }
    #else
      compare = { indexPath > $0.indexPath }
    #endif
    let result = binarySearch.findElement(in: cachedItems[indexPath.section],
                                          less: compare,
                                          match: { indexPath == $0.indexPath })
    return result
  }

  /// Returns the layout attributes for all of the cells and views
  /// in the specified rectangle.
  ///
  /// - Parameter rect: The rectangle (specified in the collection view’s coordinate system) containing the target views.
  /// - Returns: An array of layout attribute objects containing the layout information for the enclosed items and views.
  override open func layoutAttributesForElements(in rect: CGRect) -> LayoutAttributesForElements {
    let closure: (LayoutAttributes) -> Bool = scrollDirection == .horizontal
      ? { rect.maxX > $0.frame.minX }
      : { rect.maxY > $0.frame.minY }
    let result = binarySearch.findElements(in: allCachedAttributes,
                                           less: { closure($0) },
                                           match: { $0.frame.intersects(rect) })
    return result ?? allCachedAttributes.filter { $0.frame.intersects(rect) }
  }

  /// Returns the starting layout information for an item being inserted into the collection view.
  ///
  /// - Parameter itemIndexPath: The index path of the item being inserted.
  override open func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> LayoutAttributes? {
    guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else {
      return nil
    }

    return animator.initialLayoutAttributesForAppearingItem(at: itemIndexPath,
                                                            with: attributes)
  }

  /// Returns the ending layout information for an item being removed from the collection view.
  ///
  /// - Parameter itemIndexPath: The index path of the item being removed.
  /// - Returns: The layout attributes object that describes the item’s position
  ///            and properties at the end of animations.
  override open func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> LayoutAttributes? {
    guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else {
      return nil
    }

    return animator.finalLayoutAttributesForDisappearingItem(at: itemIndexPath,
                                                             with: attributes)
  }

  /// Notifies the layout object that the contents of the collection view are about to change.
  ///
  /// - Parameter updateItems: An array of CollectionViewUpdateItem objects
  //                           that identify the changes being made.
  override open func prepare(forCollectionViewUpdates updateItems: [CollectionViewUpdateItem]) {
    return animator.prepare(forCollectionViewUpdates: updateItems)
  }
}
