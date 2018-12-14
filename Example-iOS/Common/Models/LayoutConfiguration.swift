import UIKit

struct LayoutConfiguration {

    var itemsPerRow: CGFloat?
    var itemsPerCollumn: Int?
    var minimumInteritemSpacing: CGFloat?
    var minimumLineSpacing: CGFloat?
    var sectionInsets: UIEdgeInsets?
    var useDynamicHeight: Bool?

    init(itemsPerRow: CGFloat?,
         itemsPerCollumn: Int?,
         minimumInteritemSpacing: CGFloat?,
         minimumLineSpacing: CGFloat?,
         sectionInsets: UIEdgeInsets?,
         useDynamicHeight: Bool?) {
        self.itemsPerRow = itemsPerRow
        self.itemsPerCollumn = itemsPerCollumn
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInsets = sectionInsets
        self.useDynamicHeight = useDynamicHeight
    }
}

extension LayoutConfiguration: Comparable {

    static func < (lhs: LayoutConfiguration, rhs: LayoutConfiguration) -> Bool {
        return lhs.itemsPerRow == rhs.itemsPerRow &&
        lhs.itemsPerCollumn == rhs.itemsPerCollumn &&
        lhs.minimumInteritemSpacing == rhs.minimumInteritemSpacing &&
        lhs.minimumLineSpacing == rhs.minimumLineSpacing &&
        lhs.sectionInsets == rhs.sectionInsets &&
        lhs.useDynamicHeight == rhs.useDynamicHeight
    }
}
