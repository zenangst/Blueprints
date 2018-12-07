//
//  RootViewController.swift
//  Example
//
//  Created by Chris on 06/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    private var current: UIViewController

    var initialController: UIViewController = {
        let dataSourceExampleSceneViewController = UIStoryboard(name: Constants.StoryboardIdentifiers.layoutsExampleScene.rawValue, bundle: nil).instantiateInitialViewController()!
        return dataSourceExampleSceneViewController
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init() {
        let navigationController = MainNavigationController(rootViewController: initialController)
        current = navigationController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not required in the current implementation")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
}
