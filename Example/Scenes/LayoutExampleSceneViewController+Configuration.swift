//
//  LayoutExampleSceneViewController+Configuration.swift
//  Example
//
//  Created by Chris on 06/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

extension LayoutExampleSceneViewController {

    func configureControllerTitle() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.title = self?.activeLayout.title
        }
    }

    func configureNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureNavigationItems() {
        configureSettingsButton()
        configureNextLayoutButton()
    }

    private func configureSettingsButton() {
        let settingsButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                             target: self,
                                             action: #selector(routeToSettingsScene))
        navigationItem.leftBarButtonItem = settingsButton
    }

    private func configureNextLayoutButton() {
        let nextLayoutButton = UIBarButtonItem(barButtonSystemItem: .fastForward,
                                               target: self,
                                               action: #selector(configureNextLayout))
        navigationItem.rightBarButtonItem = nextLayoutButton
    }

    @objc
    private func routeToSettingsScene() {
        router?.routeToLayoutSettingsScene()
    }

    @objc
    private func configureNextLayout() {
        activeLayout.switchToNextLayout()
        configureBluePrintLayout()
        configureControllerTitle()
    }
}

extension LayoutExampleSceneViewController {

    func configureCollectionView() {
        layoutExampleCollectionView.dataSource = self
        registerCollectionViewCells()
    }

    private func registerCollectionViewCells() {
        let layoutExampleCellIdentifier = Constants
            .CollectionViewCellIdentifiers
            .layoutExampleCell
            .rawValue

        let layoutExampleCellXib = UINib(nibName: layoutExampleCellIdentifier,
                                         bundle: nil)

        layoutExampleCollectionView.register(layoutExampleCellXib,
                                             forCellWithReuseIdentifier: layoutExampleCellIdentifier)
    }
}

extension LayoutExampleSceneViewController {

    func configureBluePrintLayout() {
        configureDynamicHeight()
        switch activeLayout {
        case .vertical:
            configureVerticalLayout()
        case .horizontal:
            configureHorizontalLayout()
        case .mosaic:
            configureMosaicLayout()
        case .waterfall:
            configureWaterFallLayout()
        }
    }

    private func configureDynamicHeight() {
        dynamicCellSizeCache = [[]]
        if useDynamicHeight {
            layoutExampleCollectionView.delegate = self
        } else {
            layoutExampleCollectionView.delegate = nil
        }
    }
}
