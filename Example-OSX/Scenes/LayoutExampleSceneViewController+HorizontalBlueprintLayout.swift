//
//  LayoutExampleSceneViewController+HorizontalBlueprintLayout.swift
//  Example-OSX
//
//  Created by Chris on 21/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Blueprints
import Cocoa

extension LayoutExampleSceneViewController {

    func configureHorizontalLayout() {
        let horizontalBlueprintLayout = HorizontalBlueprintLayout(
            itemsPerRow: itemsPerRow,
            itemsPerColumn: itemsPerColumn,
            height: 95,
            minimumInteritemSpacing: minimumInteritemSpacing,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
            stickyHeaders: true,
            stickyFooters: true
        )

        let titleCollectionReusableViewSize = CGSize(width: view.bounds.width, height: 61)
        horizontalBlueprintLayout.headerReferenceSize = titleCollectionReusableViewSize
        horizontalBlueprintLayout.footerReferenceSize = titleCollectionReusableViewSize

        NSView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = horizontalBlueprintLayout
            self?.scrollLayoutExampleCollectionViewToTopItem()
        }
    }
}
