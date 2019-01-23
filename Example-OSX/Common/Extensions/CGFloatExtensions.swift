import Cocoa

extension CGFloat {

    init?(_ other: String?) {
        guard let value = other,
            let number = NumberFormatter().number(from: value) else {
                return nil
        }
        self.init(number.floatValue)
    }
}
