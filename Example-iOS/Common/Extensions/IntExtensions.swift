extension Int {

    init?(_ other: String?) {
        guard let value = other,
            let number = Int(value) else {
                return nil
        }
        self = number
    }
}
