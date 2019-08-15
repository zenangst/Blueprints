#if os(macOS)
import Cocoa
public typealias CollectionView = NSCollectionView
public typealias CollectionViewElementKind = NSCollectionView.SupplementaryElementKind
public typealias CollectionViewLayout = NSCollectionViewLayout
public typealias CollectionViewFlowLayout = NSCollectionViewFlowLayout
public typealias CollectionViewFlowLayoutDelegate = NSCollectionViewDelegateFlowLayout
public typealias CollectionViewUpdateItem = NSCollectionViewUpdateItem
public typealias CollectionViewUpdateAction = NSCollectionView.UpdateAction
public typealias EdgeInsets = NSEdgeInsets
public typealias LayoutAttributes = NSCollectionViewLayoutAttributes
public typealias LayoutAttributesForElements = [NSCollectionViewLayoutAttributes]
public typealias LayoutInvalidationContext = NSCollectionViewLayoutInvalidationContext
public typealias FlowLayoutInvalidationContext = NSCollectionViewFlowLayoutInvalidationContext
public typealias CollectionElementCategory = NSCollectionElementCategory
#else
import UIKit
public typealias CollectionView = UICollectionView
public typealias CollectionViewElementKind = String
public typealias CollectionViewLayout = UICollectionViewLayout
public typealias CollectionViewFlowLayout = UICollectionViewFlowLayout
public typealias CollectionViewFlowLayoutDelegate = UICollectionViewDelegateFlowLayout
public typealias CollectionViewUpdateItem = UICollectionViewUpdateItem
public typealias CollectionViewUpdateAction = UICollectionViewUpdateItem.Action
public typealias EdgeInsets = UIEdgeInsets
public typealias LayoutAttributes = UICollectionViewLayoutAttributes
public typealias LayoutAttributesForElements = [UICollectionViewLayoutAttributes]?
public typealias LayoutInvalidationContext = UICollectionViewLayoutInvalidationContext
public typealias FlowLayoutInvalidationContext = UICollectionViewFlowLayoutInvalidationContext
public typealias CollectionElementCategory = UICollectionView.ElementCategory
#endif

extension CollectionElementCategory {

  static var cellItem: CollectionElementCategory {
    #if os(macOS)
    return .item
    #else
    return .cell
    #endif
  }
}
