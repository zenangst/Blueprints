//
//  LayoutExampleSceneViewController+Configuration.swift
//  Example-OSX
//
//  Created by Chris on 16/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

extension LayoutExampleSceneViewController {

    func configureCollectionView() {
        layoutExampleCollectionView.dataSource = self
        registerCollectionViewItems()
        // TODO: - Register headers
        // TODO: - Register footers
    }

    private func registerCollectionViewItems() {
        let layoutExampleItemIdentifier = Constants
            .CollectionViewItemIdentifiers
            .layoutExampleItem
            .rawValue

        layoutExampleCollectionView.register(LayoutExampleCollectionViewItem.self,
                                             forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: layoutExampleItemIdentifier))
    }
}

extension LayoutExampleSceneViewController {

    func configureBluePrintLayout() {
        configureDynamicHeight()
        switch activeLayout {
        case .vertical:
            configureVerticalLayout()
        case .horizontal:
            return
        //configureHorizontalLayout()
        case .mosaic:
            return
        //configureMosaicLayout()
        case .waterfall:
            return
            //configureWaterFallLayout()
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
