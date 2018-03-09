import Cocoa

extension NSCollectionViewLayoutAttributes {
  convenience init(forCellWith indexPath: IndexPath) {
    self.init(forItemWith: indexPath)
  }
}
