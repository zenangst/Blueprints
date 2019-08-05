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

    let attributes = layoutAttributes
    let direction = ((superview as? UICollectionView)?.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection ?? .vertical
    let cellSize: CGSize
    switch direction {
    case .horizontal:
      cellSize = contentView.systemLayoutSizeFitting(contentView.frame.size,
                                                     withHorizontalFittingPriority: .required,
                                                     verticalFittingPriority: .fittingSizeLevel)
      attributes.frame.size.height = cellSize.height
    case .vertical:
      cellSize = contentView.systemLayoutSizeFitting(contentView.frame.size,
                                                     withHorizontalFittingPriority: .fittingSizeLevel,
                                                     verticalFittingPriority: .fittingSizeLevel)
      attributes.frame.size.height = cellSize.height
    @unknown default:
      fatalError("Case not implemented in current implementation")
    }

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
