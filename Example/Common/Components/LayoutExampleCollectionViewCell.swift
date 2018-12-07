//
//  LayoutExampleCollectionViewCell.swift
//  Example
//
//  Created by Chris on 06/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

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
