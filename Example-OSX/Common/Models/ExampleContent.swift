import Cocoa

struct ExampleContent {
    var title: String
    var message: String
    var iconImage: NSImage?

    init(title: String,
         message: String,
         iconImage: NSImage?) {
        self.title = title
        self.message = message
        self.iconImage = iconImage
    }
}
