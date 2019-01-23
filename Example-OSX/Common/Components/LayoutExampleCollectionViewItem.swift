import Cocoa

class LayoutExampleCollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var messageLabel: NSTextField!
    @IBOutlet weak var backgroundView: BackgroundColorView!

    override func prepareForReuse() {
        titleLabel.stringValue = ""
        messageLabel.stringValue = ""
    }
}

extension LayoutExampleCollectionViewItem {

    func configure(forExampleContent exampleContent: LayoutExampleScene.GetExampleData.ViewModel.DisplayedExampleContent?) {
        guard let exampleContent = exampleContent else {
            return
        }
        titleLabel.stringValue = exampleContent.title
        messageLabel.stringValue = exampleContent.message
    }
}
