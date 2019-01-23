import Cocoa

class TitleCollectionViewElement: NSView, NSCollectionViewElement {

    @IBOutlet weak var titleLabel: NSTextField!

    override func prepareForReuse() {
        titleLabel.stringValue = ""
    }
}

extension TitleCollectionViewElement {

    func configure(withTitle title: String) {
        titleLabel.stringValue = title
    }
}
