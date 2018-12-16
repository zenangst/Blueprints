extension Double {

    init?(_ other: String?) {
        guard let value = other,
            let doubleValue = Double(value) else {
                return nil
        }
        self = doubleValue
    }
}
