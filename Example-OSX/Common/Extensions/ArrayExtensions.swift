import Foundation

public extension Array {

    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}
