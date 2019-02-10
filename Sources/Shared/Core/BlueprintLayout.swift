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
  var previousBounds: CGRect = .zero

  //  A Boolean value indicating whether headers pin to the top of the collection view bounds during scrolling.
  public var stickyHeaders: Bool = false
  /// A Boolean value indicating whether footers pin to the top of the collection view bounds during scrolling.
  public var stickyFooters: Bool = false

  override open var collectionViewContentSize: CGSize { return contentSize }
  /// The amount of items that should appear on each row.
  public var itemsPerRow: CGFloat?
  /// A layout attributes cache, gets invalidated with the collection view and filled using the `prepare` method.
  public var cachedHeaderFooterAttributes = [HeaderFooterLayoutAttributes]()
  public var cachedHeaderFooterAttributesBySection = [[HeaderFooterLayoutAttributes]]()
  public var cachedItemAttributes = [LayoutAttributes]()
  public var cachedItemAttributesBySection = [[LayoutAttributes]]()
  public var allCachedAttributes = [LayoutAttributes]()
  var binarySearch = BinarySearch()
  var currentInvalidationContext: InvalidationContext? = nil

  /// The content size of the layout, should be set using the `prepare` method of any subclass.
  public var contentSize: CGSize = .zero
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
    stickyHeaders: Bool = false,
    stickyFooters: Bool = false,
    animator: BlueprintLayoutAnimator = DefaultLayoutAnimator()
    ) {
    self.stickyHeaders = stickyHeaders
    self.stickyFooters = stickyFooters
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
      var containerWidth = collectionView.frame.size.width

      #if os(macOS)
      if scrollDirection == .horizontal {
        containerWidth = (collectionView.enclosingScrollView?.frame.size.width) ?? (collectionView.frame.size.width)
      }
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
  func createSupplementaryLayoutAttribute(ofKind kind: BlueprintSupplementaryKind,
                                          indexPath: IndexPath,
                                          atX x: CGFloat = 0,
                                          atY y: CGFloat = 0) -> HeaderFooterLayoutAttributes {
    let layoutAttribute = HeaderFooterLayoutAttributes(
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

  func indexPathIsOutOfBounds(_ indexPath: IndexPath, for cache: [[LayoutAttributes]]) -> Bool {
    return !(indexPath.count > 0 && cache.count > 0 && indexPath.section < cache.count)
  }

  func indexOffsetForSectionHeaders() -> CGFloat {
    if headerReferenceSize.height > 0 {
      return 1
    }
    return 0
  }

  // MARK: - Overrides

  /// Tells the layout object to update the current layout.
  open override func prepare() {
    self.contentSize = .zero
    self.cachedItemAttributesBySection = []
    self.cachedHeaderFooterAttributes = []
    self.cachedItemAttributes = []
    self.cachedHeaderFooterAttributesBySection = []

    #if os(macOS)
      if let clipView = collectionView?.enclosingScrollView {
        configureHeaderFooterWidth(clipView)
      }
    #else
      headerFooterWidth = collectionView?.frame.size.width
    #endif
  }

  /// Create caches from the layout attributes produced by the layout algoritm.
  /// This method is invoked in the `prepare` method for the collection view layout.
  ///
  /// - Parameter attributes: The attributes that were created in the collection view layout.
  func createCache(with attributes: [[LayoutAttributes]]) {
    #if os(macOS)
      macOSWorkaroundCreateCache()
    #endif

    for value in attributes {
      #if os(macOS)
        let sorted = value.sorted(by: { $0.indexPath! < $1.indexPath! })
        let items = sorted.filter({ $0.representedElementCategory == .item })
        let headerFooters = sorted
          .filter({ $0.representedElementCategory == .supplementaryView })
          .compactMap({ $0 as? HeaderFooterLayoutAttributes })
        self.cachedHeaderFooterAttributesBySection.append(headerFooters)
        self.cachedItemAttributesBySection.append(items)
      #else
        let sorted = value.sorted(by: { $0.indexPath < $1.indexPath })
        let items = sorted.filter({ $0.representedElementCategory == .cell })
        let headerFooters = sorted
          .filter({ $0.representedElementCategory == .supplementaryView })
          .compactMap({ $0 as? HeaderFooterLayoutAttributes })
        self.cachedHeaderFooterAttributesBySection.append(headerFooters)
        self.cachedItemAttributesBySection.append(items)
      #endif
    }

    allCachedAttributes = Array(attributes.joined())

    switch scrollDirection {
    case .horizontal:
      allCachedAttributes = allCachedAttributes.sorted(by: { $0.frame.minX < $1.frame.minX })
    case .vertical:
      allCachedAttributes = allCachedAttributes.sorted(by: { $0.frame.minY < $1.frame.minY })
    }

    self.cachedItemAttributes = allCachedAttributes.filter({
      #if os(macOS)
      return $0.representedElementCategory == .item
      #else
      return $0.representedElementCategory == .cell
      #endif
    })
  }

  /// Returns the layout attributes for the item at the specified index path.
  ///
  /// - Parameter indexPath: The index path of the item whose attributes are requested.
  /// - Returns: A layout attributes object containing the information to apply to the item’s cell.
  override open func layoutAttributesForItem(at indexPath: IndexPath) -> LayoutAttributes? {
    if indexPathIsOutOfBounds(indexPath, for: cachedItemAttributesBySection) {
        return nil
    }

    let compare: (LayoutAttributes) -> Bool
    #if os(macOS)
      compare = { indexPath > $0.indexPath! }
    #else
      compare = { indexPath > $0.indexPath }
    #endif
    let result = binarySearch.findElement(in: cachedItemAttributesBySection[indexPath.section],
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
      ? { rect.maxX >= $0.frame.minX }
      : { rect.maxY >= $0.frame.minY }
    var result = binarySearch.findElements(in: cachedItemAttributes,
                                           padding: Int(itemsPerRow ?? 0),
                                           less: { closure($0) },
                                           match: { $0.frame.intersects(rect) }) ?? []

    if let collectionView = collectionView {
      #if os(macOS)
      let visibleRect = CGRect(origin: CGPoint(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y),
                        size: collectionView.enclosingScrollView!.visibleRect.size)
      #else
      let visibleRect = CGRect(origin: CGPoint(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y),
                               size: collectionView.frame.size)
      #endif
      let headerFooter = cachedHeaderFooterAttributes.filter({ $0.frame.intersects(visibleRect) })
      result.append(contentsOf: headerFooter)
    }

    return !result.isEmpty ? result : cachedItemAttributes.filter { $0.frame.intersects(rect) }
  }

  open override func invalidateLayout(with context: LayoutInvalidationContext) {
    if context.invalidateEverything == false {
      positionHeadersAndFooters(with: context)

      if context.invalidatedSupplementaryIndexPaths != nil {
        super.invalidateLayout(with: context)
      }
    } else {
      super.invalidateLayout(with: context)
    }
  }

  open override func invalidationContext(forBoundsChange newBounds: CGRect) -> FlowLayoutInvalidationContext {
    let context = InvalidationContext()
    context.shouldInvalidateEverything = previousBounds == newBounds
    return context
  }

  override open class var invalidationContextClass: AnyClass {
    return InvalidationContext.self
  }

  override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    if previousBounds.width != newBounds.width {
      previousBounds = newBounds
    }
    return true
  }

  internal func positionHeadersAndFooters(with context: LayoutInvalidationContext? = nil) {
    guard let collectionView = collectionView else { return }

    #if os(macOS)
    let visibleRect = CGRect(origin: CGPoint(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y),
                             size: collectionView.enclosingScrollView!.visibleRect.size)
    #else
    let visibleRect = CGRect(origin: CGPoint(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y),
                             size: collectionView.frame.size)
    #endif

    var results = cachedHeaderFooterAttributes
    if collectionView.contentOffset.y > 0 || collectionView.contentOffset.x > 0 {
      results = results.filter({
        switch scrollDirection {
        case .vertical:
          return collectionView.contentOffset.y >= $0.min && collectionView.contentOffset.y <= $0.max
        case .horizontal:
          return collectionView.contentOffset.x >= $0.min && collectionView.contentOffset.x <= $0.max
        }
      })
    }

    if stickyHeaders, let header = results.filter({ $0.representedElementKind == CollectionView.collectionViewHeaderType }).first {
      switch scrollDirection {
      case .vertical:
        if collectionView.contentOffset.y < 0 {
          header.frame.origin.y = 0
        } else {
          header.frame.origin.y = min(collectionView.contentOffset.y, header.max)
        }
      case .horizontal:
        header.frame.origin.x = min(collectionView.contentOffset.x, header.max)
      }

      if let invalidationContext = context as? InvalidationContext {
        #if os(macOS)
        invalidationContext.headerIndexPaths = [header.indexPath!]
        #else
        invalidationContext.headerIndexPaths = [header.indexPath]
        #endif
      }
    }

    if stickyFooters, let footer = results.filter({ $0.representedElementKind == CollectionView.collectionViewFooterType }).first {
      switch scrollDirection {
      case .vertical:
        footer.frame.origin.y = min(visibleRect.maxY - footer.frame.height, footer.max + footer.frame.height)
      case .horizontal:
        footer.frame.origin.x = min(collectionView.contentOffset.x, footer.max)
      }

      if let invalidationContext = context as? InvalidationContext {
        #if os(macOS)
        invalidationContext.footerIndexPaths = [footer.indexPath!]
        #else
        invalidationContext.footerIndexPaths = [footer.indexPath]
        #endif
      }
    }
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
