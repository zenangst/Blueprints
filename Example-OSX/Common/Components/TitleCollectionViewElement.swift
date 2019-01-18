//
//  TitleCollectionViewElement.swift
//  Example-OSX
//
//  Created by Chris on 18/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

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
