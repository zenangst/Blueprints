import Cocoa

extension NSEdgeInsets: Equatable {

    public static func == (lhs: NSEdgeInsets, rhs: NSEdgeInsets) -> Bool {
        return lhs.bottom == rhs.bottom &&
            lhs.left == rhs.left &&
            lhs.right == rhs.right &&
            lhs.top == rhs.top
    }
}
