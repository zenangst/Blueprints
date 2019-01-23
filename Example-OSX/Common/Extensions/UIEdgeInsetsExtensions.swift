import Cocoa

extension NSEdgeInsets {

    init?(top: String?,
          left: String?,
          bottom: String?,
          right: String?) {
        guard let topSectionInset = CGFloat(top),
            let leftSectionInset = CGFloat(left),
            let bottomSectionInset = CGFloat(bottom),
            let rightSectionInset = CGFloat(right) else {
                return nil
        }
        self = NSEdgeInsets(top: topSectionInset,
                            left: leftSectionInset,
                            bottom: bottomSectionInset,
                            right: rightSectionInset)
    }
}
