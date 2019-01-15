//
//  RootViewController.swift
//  Example-OSX
//
//  Created by Chris on 14/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

class RootViewController: NSViewController {

    private var current: NSViewController

    init<T: NSViewController>(withNibName nibName: String, controllerType: T.Type) {
        let controller = T(nibName: nibName, bundle: nil)
        current = controller

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        self.view = NSView()
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        configureAppearence()
        addCurrentView()
    }
}

private extension RootViewController {

    // TODO: - Complete implementation
    func configureAppearence() {

    }

    func addCurrentView() {
        view.addSubview(current.view)
        configureCurrentViewsConstraints()
    }

    func configureCurrentViewsConstraints() {
        current.view.translatesAutoresizingMaskIntoConstraints = false

        let topConstraint = NSLayoutConstraint(
            item: current.view,
            attribute: .top,
            relatedBy: .equal,
            toItem: view,
            attribute: .top,
            multiplier: 1.0,
            constant: 0)
        let leftConstraint = NSLayoutConstraint(
            item: current.view,
            attribute: .leading,
            relatedBy: .equal,
            toItem: view,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0)
        let rightConstraint = NSLayoutConstraint(
            item: current.view,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: view,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0)
        let bottomConstraint = NSLayoutConstraint(
            item: current.view,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0)

        view.addConstraints([topConstraint,
                             leftConstraint,
                             rightConstraint,
                             bottomConstraint])
    }
}
