enum BlueprintLayout {
    case vertical
    case horizontal
    case mosaic
}

extension BlueprintLayout {

    mutating func switchToNextLayout() {
        switch self {
        case .vertical:
            self = .horizontal
        case .horizontal:
            self = .mosaic
        case .mosaic:
            self = .vertical
        }
    }

    mutating func switchToPreviousLayout() {
        switch self {
        case .vertical:
            self = .mosaic
        case .horizontal:
            self = .vertical
        case .mosaic:
            self = .horizontal
        }
    }
}

extension BlueprintLayout {

    var title: String {
        switch self {
        case .vertical:
            return "Vertical Blueprint"
        case .horizontal:
            return "Horizontal Blueprint"
        case .mosaic:
            return "Mosaic Blueprint"
        }
    }
}
