import UIKit

class LayoutExampleCollectionViewCell: UICollectionViewCell {

  @IBOutlet private weak var iconImageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var messageLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

    configureStyle()
  }

  override func prepareForReuse() {
    titleLabel.text = nil
    messageLabel.text = nil
  }

  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    setNeedsLayout()
    layoutIfNeeded()
    let cellHeight: CGFloat = 0
    let cellTargetSize = CGSize(width: contentView.frame.size.width,
                                height: cellHeight)
    let cellSize = contentView.systemLayoutSizeFitting(cellTargetSize,
                                                       withHorizontalFittingPriority: .defaultHigh,
                                                       verticalFittingPriority: .fittingSizeLevel)
    let attributes = layoutAttributes
    attributes.frame.size.height = cellSize.height
    return attributes
  }
}

extension LayoutExampleCollectionViewCell {

  func configure(forExampleContent exampleContent: LayoutExampleScene.GetExampleData.ViewModel.DisplayedExampleContent?) {
    guard let exampleContent = exampleContent else {
      return
    }
    titleLabel.text = exampleContent.title
    messageLabel.text = exampleContent.message
  }
}

private extension LayoutExampleCollectionViewCell {

  func configureStyle() {
    layer.addShadow(color: Constants.cellShadowColor)
    layer.roundCorners(radius: Constants.cellCornerRadius)
  }
}
