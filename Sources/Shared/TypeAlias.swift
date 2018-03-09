#if os(macOS)
  import Cocoa
  public typealias CollectionView = NSCollectionView
  public typealias CollectionViewElementKind = NSCollectionView.SupplementaryElementKind
  public typealias CollectionViewFlowLayout = NSCollectionViewFlowLayout
  public typealias CollectionViewFlowLayoutDelegate = NSCollectionViewDelegateFlowLayout
  public typealias CollectionViewUpdateItem = NSCollectionViewUpdateItem
  public typealias CollectionViewUpdateAction = NSCollectionView.UpdateAction
  public typealias EdgeInsets = NSEdgeInsets
  public typealias LayoutAttributes = NSCollectionViewLayoutAttributes
  public typealias LayoutAttributesForElements = [NSCollectionViewLayoutAttributes]
#else
  import UIKit
  public typealias CollectionView = UICollectionView
  public typealias CollectionViewElementKind = String
  public typealias CollectionViewFlowLayout = UICollectionViewFlowLayout
  public typealias CollectionViewFlowLayoutDelegate = UICollectionViewDelegateFlowLayout
  public typealias CollectionViewUpdateItem = UICollectionViewUpdateItem
  public typealias CollectionViewUpdateAction = UICollectionUpdateAction
  public typealias EdgeInsets = UIEdgeInsets
  public typealias LayoutAttributes = UICollectionViewLayoutAttributes
  public typealias LayoutAttributesForElements = [UICollectionViewLayoutAttributes]?
  #endif
