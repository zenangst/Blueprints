//
//  LayoutSettingsSceneViewController+KeyboardAvoidableProtocol.swift
//  Example
//
//  Created by Chris on 10/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

extension LayoutSettingsSceneViewController: KeyboardAvoidableProtocol {

    var layoutConstraintsToAdjust: [NSLayoutConstraint] {
        return [mainScrollViewBottomConstraint]
    }
}
