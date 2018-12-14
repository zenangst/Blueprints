import UIKit

struct ExampleContent {
    var title: String
    var message: String
    var iconImage: UIImage?

    init(title: String,
         message: String,
         iconImage: UIImage?) {
        self.title = title
        self.message = message
        self.iconImage = iconImage
    }
}
