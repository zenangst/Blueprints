//
//  MainNavigationController.swift
//  Example
//
//  Created by Chris on 06/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }
}

private extension MainNavigationController {

    func configureNavigationBar() {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .blueprintsBlue
        navigationBar.backgroundColor = .blueprintsBlue
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.barTintColor = UIColor(patternImage: #imageLiteral(resourceName: "Blueprints-background"))
    }
}
