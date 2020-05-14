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
  public var cachedSupplementaryAttributes = [SupplementaryLayoutAttributes]()
  public var cachedSupplementaryAttributesBySection = [[SupplementaryLayoutAttributes]]()
  public var cachedItemAttributes = [LayoutAttributes]()
  public var cachedItemAttributesBySection = [[LayoutAttributes]]()
  public var allCachedAttributes = [LayoutAttributes]()
  public var preferredLayoutAttributesSizes = [[IndexPath: CGSize]]()

  var hasDelegate: Bool = false
  var binarySearch = BinarySearch()
  var prepareAllowed = true
  var previousContentOffset: CGFloat = 0

  /// The content size of the layout, should be set using the `prepare` method of any subclass.
  public var contentSize: CGSize = .zero
  /// The number of sections in the collection view.
  var numberOfSections: Int { return resolveCollectionView({ $0.dataSource?.numberOfSections?(in: $0) },
                                                           defaultValue: 1) }
  /// A layout animator object, defaults to `DefaultLayoutAnimator`.
  var animator: BlueprintLayoutAnimator
  var supplementaryWidth: CGFloat = 0
  var collectionViewWidth: CGFloat = 0
  var calculatedItemWidth: CGFloat = 0

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
    var defaultValue: CGSize = itemSize

    if !preferredLayoutAttributesSizes.isEmpty {
      defaultValue = preferredLayoutAttributesSizes[indexPath.section][indexPath] ?? itemSize
    } else {
      defaultValue.width = max(itemSize.width, estimatedItemSize.width)
      defaultValue.height = max(itemSize.height, estimatedItemSize.height)
    }

    if let itemsPerRow = itemsPerRow, itemsPerRow > 0 {
      let height: CGFloat
      if hasDelegate {
        height = resolveCollectionView({ collectionView -> CGSize? in
          return (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(collectionView,
                                                                                                 layout: self,
                                                                                                 sizeForItemAt: indexPath)
        }, defaultValue: defaultValue).height
      } else {
        height = defaultValue.height
      }
      return CGSize(width: calculatedItemWidth, height: height)
    } else {
      if hasDelegate, let delegate = collectionView?.delegate as? CollectionViewFlowLayoutDelegate {
        return resolveCollectionView({ collectionView -> CGSize? in
          return delegate.collectionView?(collectionView,
                                          layout: self,
                                          sizeForItemAt: indexPath)
        }, defaultValue: defaultValue)
      } else {
        return defaultValue
      }
    }
  }

  /// Resolve the size of SupplementaryView at index path.
  /// If the collection view's delegate conforms to `(UI/NS)CollectionViewDelegateFlowLayout`, it will
  /// query the delegate for the size of the SupplementaryView.
  /// It defaults to using the `headerReferenceSize` or `footerReferenceSize` property on collection view flow layout.
  ///
  /// - Parameter indexPath: The index path of the supplementaryView.
  /// - Returns: The desired size of the item at the index path.
  func resolveSizeForSupplementaryView(ofKind kind: BlueprintSupplementaryKind, at indexPath: IndexPath) -> CGSize {
    switch kind {
    case .header:
      var height: CGFloat = headerReferenceSize.height
      if hasDelegate {
        height = resolveCollectionView({ collectionView -> CGSize? in
          return (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(collectionView,
                                                                                                 layout: self,
                                                                                                 referenceSizeForHeaderInSection: indexPath.section)
        }, defaultValue: headerReferenceSize).height
      }

      let width: CGFloat
      if headerReferenceSize.width > 0 {
        width = headerReferenceSize.width
      } else {
        width = supplementaryWidth
      }

      let size = CGSize(
        width: width,
        height: height
      )

      return size
    case .footer:
      var height: CGFloat = footerReferenceSize.height
      if hasDelegate {
        height = resolveCollectionView({ collectionView -> CGSize? in
          return (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(collectionView,
                                                                                                 layout: self,
                                                                                                 referenceSizeForFooterInSection: indexPath.section)
        }, defaultValue: footerReferenceSize).height
      }

      let width: CGFloat
      if footerReferenceSize.width > 0 {
        width = footerReferenceSize.width
      } else {
        width = supplementaryWidth
      }

      let size = CGSize(
        width: width,
        height: height
      )

      return size
    }
  }

  /// Resolve the minimumLineSpacingForSectionAt.
  /// If the collection view's delegate conforms to `(UI/NS)CollectionViewDelegateFlowLayout`, it will
  /// query the delegate for the minimumLineSpacing.
  /// It defaults to using the `minimumLineSpacing` property on collection view flow layout.
  ///
  /// - Parameter section: The section of the collection view.
  /// - Returns: The desired lineSpacing of the section.
  func resolveMinimumLineSpacing(forSectionAt section: Int) -> CGFloat {
    guard hasDelegate else { return minimumLineSpacing }
    return resolveCollectionView({ collectionView -> CGFloat? in
      return (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(collectionView,
                                                                                             layout: self,
                                                                                             minimumLineSpacingForSectionAt: section)
    }, defaultValue: minimumLineSpacing)
  }

  /// Resolve the minimumInteritemSpacingForSectionAt.
  /// If the collection view's delegate conforms to `(UI/NS)CollectionViewDelegateFlowLayout`, it will
  /// query the delegate for the minimumInteritemSpacing.
  /// It defaults to using the `minimumInteritemSpacing` property on collection view flow layout.
  ///
  /// - Parameter section: The section of the collection view.
  /// - Returns: The desired minimumInteritemSpacing of the section.
  func resolveMinimumInteritemSpacing(forSectionAt section: Int) -> CGFloat {
    guard hasDelegate else { return minimumInteritemSpacing }
    return resolveCollectionView({ collectionView -> CGFloat? in
      return (collectionView.delegate as? CollectionViewFlowLayoutDelegate)?.collectionView?(collectionView,
                                                                                             layout: self,
                                                                                             minimumInteritemSpacingForSectionAt: section)
    }, defaultValue: minimumInteritemSpacing)
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

  func indexOffsetForSectionHeaders(at indexPath: IndexPath) -> CGFloat {
    if resolveSizeForSupplementaryView(ofKind: .header, at: indexPath).height > 0 {
      return 1
    }
    return 0
  }

  // MARK: - Overrides

  /// Tells the layout object to update the current layout.
  open override func prepare() {
    self.hasDelegate = collectionView?.delegate as? CollectionViewFlowLayoutDelegate != nil
    self.animator.collectionViewFlowLayout = self
    self.contentSize = .zero
    self.cachedItemAttributesBySection = []
    self.cachedSupplementaryAttributes = []
    self.cachedItemAttributes = []
    self.cachedSupplementaryAttributesBySection = []

    #if os(macOS)
      if let clipView = collectionView?.enclosingScrollView {
        configureSupplementaryWidth(clipView)
        collectionViewWidth = clipView.frame.size.width
        calculatedItemWidth = calculateItemWidth(itemsPerRow ?? 1, containerWidth: collectionViewWidth)
      }
    #else
      supplementaryWidth = collectionView?.frame.size.width ?? 0
      collectionViewWidth = collectionView?.documentRect.width ?? 0
      calculatedItemWidth = calculateItemWidth(itemsPerRow ?? 1, containerWidth: collectionViewWidth)
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
      let items = value.filter({ $0.representedElementCategory == .cellItem })
      let supplementaryLayoutAttributes = value.compactMap({ $0 as? SupplementaryLayoutAttributes })
      cachedSupplementaryAttributesBySection.append(supplementaryLayoutAttributes)
      cachedItemAttributesBySection.append(items)
      cachedSupplementaryAttributes.append(contentsOf: supplementaryLayoutAttributes)
      cachedItemAttributes.append(contentsOf: items)
      allCachedAttributes.append(contentsOf: value)
    }
  }

  /// Returns the layout attributes for the item at the specified index path.
  ///
  /// - Parameter indexPath: The index path of the item whose attributes are requested.
  /// - Returns: A layout attributes object containing the information to apply to the item’s cell.
  override open func layoutAttributesForItem(at indexPath: IndexPath) -> LayoutAttributes? {
    if indexPathIsOutOfBounds(indexPath, for: cachedItemAttributesBySection) {
      return nil
    }

    let lower: (LayoutAttributes) -> Bool
    let upper: (LayoutAttributes) -> Bool
    let less: (LayoutAttributes) -> Bool
    #if os(macOS)
    upper = { $0.indexPath! >= indexPath }
    lower = { $0.indexPath! <= indexPath }
    less =  { $0.indexPath! < indexPath }
    #else
    upper = { $0.indexPath >= indexPath }
    lower = { $0.indexPath <= indexPath }
    less =  { $0.indexPath < indexPath }
    #endif
    let result = binarySearch.findElement(in: cachedItemAttributesBySection[indexPath.section],
                                          upper: upper,
                                          lower: lower,
                                          less: less,
                                          match: { indexPath == $0.indexPath })
    return result
  }

  /// Returns the layout attributes for all of the cells and views
  /// in the specified rectangle.
  ///
  /// - Parameter rect: The rectangle (specified in the collection view’s coordinate system) containing the target views.
  /// - Returns: An array of layout attribute objects containing the layout information for the enclosed items and views.
  override open func layoutAttributesForElements(in rect: CGRect) -> LayoutAttributesForElements {
    let upper: (LayoutAttributes) -> Bool
    let lower: (LayoutAttributes) -> Bool
    let less: (LayoutAttributes) -> Bool

    switch scrollDirection {
    case .horizontal:
      upper = { attributes in attributes.frame.maxX >= rect.minX }
      lower = { attributes in attributes.frame.minX <= rect.maxX }
      less =  { attributes in attributes.frame.maxX <= rect.minX }
    case .vertical:
      upper = { attributes in attributes.frame.maxY >= rect.minY }
      lower = { attributes in attributes.frame.minY <= rect.maxY }
      less =  { attributes in attributes.frame.maxY <= rect.minY }
    @unknown default:
      fatalError("Case not implemented in current implementation")
    }

    var items = binarySearch.findElements(in: cachedItemAttributes,
                                          upper: upper,
                                          lower: lower,
                                          less: less,
                                          match: { $0.frame.intersects(rect) })
    let supplementary = binarySearch.findElements(in: cachedSupplementaryAttributes,
                                                  upper: upper,
                                                  lower: lower,
                                                  less: less,
                                                  match: { $0.frame.intersects(rect) })
    items.append(contentsOf: supplementary)
    return items
  }

  open override func invalidateLayout(with context: LayoutInvalidationContext) {
    prepareAllowed = true

    if context.invalidateEverything == false {
      positionHeadersAndFooters(with: context)
      if context.invalidatedSupplementaryIndexPaths != nil {
        super.invalidateLayout(with: context)
      }
    } else {
      super.invalidateLayout(with: FlowLayoutInvalidationContext())
    }
  }

  open override func invalidationContext(forBoundsChange newBounds: CGRect) -> FlowLayoutInvalidationContext {
    let context = BlueprintInvalidationContext()
    context.shouldInvalidateEverything = previousBounds == newBounds
    return context
  }

  override open class var invalidationContextClass: AnyClass {
    return BlueprintInvalidationContext.self
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
    NSAnimationContext.current.duration = 0.0
    NSAnimationContext.current.allowsImplicitAnimation = false
    let visibleRect = collectionView.visibleRect
    #else
    let visibleRect = CGRect(origin: collectionView.contentOffset,
                             size: collectionView.frame.size)
    #endif

    let results = cachedSupplementaryAttributes.filter({
      switch scrollDirection {
      case .vertical:
        return ((visibleRect.maxY >= $0.min && visibleRect.origin.y <= $0.max) || visibleRect.intersects($0.frame))
      case .horizontal:
        if visibleRect.origin.x < 0 {
          return $0.frame.intersects(visibleRect)
        } else {
          return (visibleRect.origin.x >= $0.min && visibleRect.origin.x <= $0.max)
        }
      @unknown default:
        fatalError("Case not implemented in current implementation")
      }
    })

    if stickyHeaders {
      let headers = results.filter({ $0.representedElementKind == CollectionView.collectionViewHeaderType })
      for header in headers {
        switch scrollDirection {
        case .vertical:
          if collectionView.contentOffset.y < 0 {
            header.frame.origin.y = max(0, header.min)
          } else {
            header.frame.origin.y = min(max(visibleRect.minY, header.min), header.max)
          }
        case .horizontal:
          header.frame.origin.x = min(max(collectionView.contentOffset.x, header.min), header.max - header.frame.size.width)
        @unknown default:
          fatalError("Case not implemented in current implementation")
        }

        if let invalidationContext = context as? BlueprintInvalidationContext {
          #if os(macOS)
          invalidationContext.headerIndexPaths += [header.indexPath!]
          #else
          invalidationContext.headerIndexPaths += [header.indexPath]
          #endif
        }
      }
    }

    if stickyFooters {
      let footers = results.filter({ $0.representedElementKind == CollectionView.collectionViewFooterType })
      for footer in footers {
        switch scrollDirection {
        case .vertical:
          footer.frame.origin.y = min(max(visibleRect.maxY - footer.frame.height, footer.min), footer.max)
        case .horizontal:
          footer.frame.origin.x = min(max(collectionView.contentOffset.x, footer.min), footer.max - footer.frame.size.width)
        @unknown default:
          fatalError("Case not implemented in current implementation")
        }

        if let invalidationContext = context as? BlueprintInvalidationContext {
          #if os(macOS)
          invalidationContext.footerIndexPaths += [footer.indexPath!]
          #else
          invalidationContext.footerIndexPaths += [footer.indexPath]
          #endif
        }
      }
    }
  }

  open override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: LayoutAttributes,
                                            withOriginalAttributes originalAttributes: LayoutAttributes) -> Bool {
    guard estimatedItemSize.width > 0 || estimatedItemSize.height > 0 else {
      return false
    }
    #if os(macOS)
    let indexPath = originalAttributes.indexPath!
    #else
    let indexPath = originalAttributes.indexPath
    #endif
    let currentAttributes = cachedItemAttributesBySection[indexPath.section][indexPath.item]
    let distanceDiff = distanceBetweenSizes(preferredAttributes.size, rhs: currentAttributes.size)
    let shouldInvalidateLayout = !(sizesAreEqual(preferredAttributes.size, rhs: currentAttributes.size)) &&
      (distanceDiff.width > 1 || distanceDiff.height > 1)

    if shouldInvalidateLayout && preferredLayoutAttributesSizes.isEmpty {
      preferredLayoutAttributesSizes = Array<[IndexPath: CGSize]>.init(repeating: [IndexPath: CGSize](),
                                                             count: numberOfSections)
    }

    if indexPath.section < preferredLayoutAttributesSizes.count - 1,
      indexPath.item < preferredLayoutAttributesSizes[indexPath.section].count - 1 {
      if sizesAreEqual(preferredAttributes.size, rhs: preferredLayoutAttributesSizes[indexPath.section][indexPath]) {
        return false
      }
    }

    return shouldInvalidateLayout
  }

  open override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: LayoutAttributes,
                                         withOriginalAttributes originalAttributes: LayoutAttributes) -> BlueprintInvalidationContext {
    #if os(macOS)
    let indexPath = originalAttributes.indexPath!
    #else
    let indexPath = originalAttributes.indexPath
    #endif

    let currentAttributes = cachedItemAttributesBySection[indexPath.section][indexPath.item]
    let context = BlueprintInvalidationContext()
    context.shouldInvalidateEverything = false
    let indexOf = cachedItemAttributes.firstIndex(of: currentAttributes) ?? indexPath.item
    let filteredAttributes = cachedItemAttributes[indexOf...]

    var contentWidthAdjustment: CGFloat = preferredAttributes.frame.size.width - currentAttributes.frame.size.width
    if preferredAttributes.frame.size.width == -1 {
      contentWidthAdjustment = 0
    }

    preferredLayoutAttributesSizes[indexPath.section][indexPath] = preferredAttributes.size

    var contentHeightAdjustment: CGFloat = preferredAttributes.frame.size.height - currentAttributes.frame.size.height
    if preferredAttributes.frame.size.height == -1 {
      contentHeightAdjustment = 0
    }

    for attributes in filteredAttributes.filter({ $0.frame.origin.y == currentAttributes.frame.origin.y && $0 != currentAttributes }) {
      attributes.frame.origin.x += contentWidthAdjustment
    }

    for attributes in filteredAttributes.filter({ $0.frame.origin.x == currentAttributes.frame.origin.x && $0 != currentAttributes }) {
      attributes.frame.origin.y += contentHeightAdjustment
    }

    // The size of the preferred attributes are constrainted to be larger than -1,
    // if they are set to negative value the estimated item size will be used.
    currentAttributes.frame.size.width = preferredAttributes.frame.size.width > -1
      ? preferredAttributes.frame.size.width
      : estimatedItemSize.width
    currentAttributes.frame.size.height = preferredAttributes.frame.size.height > -1
      ? preferredAttributes.frame.size.height
      : estimatedItemSize.height

    var newContentSize: CGSize = contentSize
    var previousSectionSize: CGSize?
    for (offset, section) in cachedItemAttributesBySection.enumerated() {
      if let largestY = section.sorted(by: { $0.frame.maxY > $1.frame.maxY }).first?.frame.maxY,
        let largestX = section.sorted(by: { $0.frame.maxX > $1.frame.maxX }).first?.frame.maxX {

        let headerAttribute = cachedSupplementaryAttributesBySection[offset].filter({ $0.representedElementKind == CollectionView.collectionViewHeaderType }).first
        let footerAttribute = cachedSupplementaryAttributesBySection[offset].filter({ $0.representedElementKind == CollectionView.collectionViewFooterType }).first

        switch scrollDirection {
        case .horizontal:
          newContentSize.width = largestX
          newContentSize.height = largestX
          headerAttribute?.max = newContentSize.width
          footerAttribute?.max = newContentSize.width

          if let previousSectionSize = previousSectionSize,
            let headerAttribute = headerAttribute,
            let footerAttribute = footerAttribute {
            headerAttribute.frame.origin.x = previousSectionSize.width
            headerAttribute.min = headerAttribute.frame.origin.x
            footerAttribute.min = headerAttribute.frame.origin.x
          }
        case .vertical:
          newContentSize.height = largestY

          if let headerAttribute = headerAttribute, let footerAttribute = footerAttribute {
            headerAttribute.max = newContentSize.height
            footerAttribute.max = newContentSize.height - footerReferenceSize.height

            if let previousSectionSize = previousSectionSize {
              headerAttribute.frame.origin.y = previousSectionSize.height + headerReferenceSize.height + sectionInset.bottom
              headerAttribute.min = headerAttribute.frame.origin.y
              footerAttribute.min = headerAttribute.frame.origin.y
            }
          }
        @unknown default:
          fatalError("Case not implemented in current implementation")
        }

        previousSectionSize = newContentSize
        positionHeadersAndFooters()
      }
    }

    if scrollDirection == .vertical {
      contentSize.height = newContentSize.height + headerReferenceSize.height + sectionInset.bottom
      context.contentSizeAdjustment = newContentSize
    }

    prepareAllowed = false
    super.invalidateLayout(with: context)
    prepareAllowed = true

    return context
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
    super.prepare(forCollectionViewUpdates: updateItems)
    return animator.prepare(forCollectionViewUpdates: updateItems)
  }

  /// Check if two sizes are equal, it rounds the value before checking `width` and `height`.
  /// - Parameters:
  ///   - lhs: Left-hand size
  ///   - rhs: Right-hand size
  private func sizesAreEqual(_ lhs: CGSize, rhs: CGSize?) -> Bool {
    return lhs.width.rounded() == rhs?.width.rounded()
      && lhs.height.rounded() == rhs?.height.rounded()
  }

  private func distanceBetweenSizes(_ lhs: CGSize, rhs: CGSize) -> CGSize {
    let width = lhs.width > rhs.width
      ? lhs.width - rhs.width
      : rhs.width - lhs.width

    let height = lhs.height > rhs.height
    ? lhs.height - rhs.height
    : rhs.height - lhs.height

    return CGSize(width: abs(width), height: abs(height))
  }
}
