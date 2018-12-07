//
//  LayoutExampleSceneViewController+Configuration.swift
//  Example
//
//  Created by Chris on 06/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

extension LayoutExampleSceneViewController {

    func configureNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureNavigationItems() {
        configureNextLayoutButton()
    }

    private func configureNextLayoutButton() {
        let nextLayoutButton = UIBarButtonItem(barButtonSystemItem: .fastForward,
                                               target: self,
                                               action: #selector(configureNextLayout))
        navigationItem.rightBarButtonItem = nextLayoutButton
    }

    @objc
    private func configureNextLayout() {
        activeLayout.switchToNextLayout()
        configureBluePrintLayout()
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
}

// TODO: - Move to there own file so it's easy to follow as a reader of the example project.. keeps evreything seperated.
import Blueprints
import UIKit

private extension LayoutExampleSceneViewController {

    func configureVerticalLayout() {
        let verticalBlueprintLayout = VerticalBlueprintLayout(
            itemsPerRow: itemsPerRow,
            itemSize: CGSize(width: 200,
                             height: 95),
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: EdgeInsets(top: 10,
                                     left: 10,
                                     bottom: 10,
                                     right: 10),
            stickyHeaders: true,
            stickyFooters: true
        )
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = verticalBlueprintLayout
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
    }

    func configureHorizontalLayout() {
        let horizontalBlueprintLayout = HorizontalBlueprintLayout(
            itemsPerRow: itemsPerRow + 0.1,
            itemsPerColumn: itemsPerColumn,
            itemSize: CGSize(width: 200,
                             height: 95),
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: EdgeInsets(top: 10,
                                     left: 10,
                                     bottom: 10,
                                     right: 10),
            stickyHeaders: true,
            stickyFooters: true
        )
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = horizontalBlueprintLayout
            self?.layoutExampleCollectionView.contentOffset.x = 0
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
    }

    func configureMosaicLayout() {
        let mosaicBlueprintLayout = VerticalMosaicBlueprintLayout(
            itemSize: CGSize.init(width: 50,
                                  height: 400),
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: EdgeInsets(top: 10,
                                     left: 10,
                                     bottom: 10,
                                     right: 10),
            patterns: [
                MosaicPattern(alignment: .left,
                              direction: .vertical,
                              amount: 2,
                              multiplier: 0.6),
                MosaicPattern(alignment: .left,
                              direction: .horizontal,
                              amount: 2,
                              multiplier: 0.33),
                MosaicPattern(alignment: .left,
                              direction: .vertical,
                              amount: 1,
                              multiplier: 0.5),
                MosaicPattern(alignment: .left,
                              direction: .vertical,
                              amount: 1,
                              multiplier: 0.5)
            ])
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = mosaicBlueprintLayout
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
    }

    func configureWaterFallLayout() {
        let waterfallBlueprintLayout = VerticalWaterfallBlueprintLayout(
            itemsPerRow: itemsPerRow,
            itemSize: CGSize.init(width: 50,
                                  height: 95),
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: EdgeInsets(top: 10,
                                     left: 10,
                                     bottom: 10,
                                     right: 10)
        )
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = waterfallBlueprintLayout
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
    }
}
