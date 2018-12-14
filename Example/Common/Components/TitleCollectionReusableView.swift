//
//  TitleCollectionReusableView.swift
//  EMISHealth
//
//  Created by Chris on 24/10/2018.
//  Copyright © 2018 EMIS Health. All rights reserved.
//

import UIKit

class TitleCollectionReusableView: UICollectionReusableView {

    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        translatesAutoresizingMaskIntoConstraints = false
    }

    override func prepareForReuse() {
        titleLabel.text = nil
    }
}

extension TitleCollectionReusableView {

    func configure(withTitle title: String) {
        titleLabel.text = title
    }
}
