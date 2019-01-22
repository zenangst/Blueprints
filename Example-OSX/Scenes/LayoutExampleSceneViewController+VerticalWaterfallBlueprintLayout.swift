//
//  LayoutExampleSceneViewController+VerticalWaterfallBlueprintLayout.swift
//  Example-OSX
//
//  Created by Chris on 21/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Blueprints
import Cocoa

extension LayoutExampleSceneViewController {

    func configureWaterFallLayout() {
        let waterfallBlueprintLayout = VerticalWaterfallBlueprintLayout(
            itemsPerRow: itemsPerRow,
            itemSize: CGSize.init(width: 50,
                                  height: 95),
            minimumInteritemSpacing: minimumInteritemSpacing,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets
        )

        NSView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = waterfallBlueprintLayout
            self?.scrollLayoutExampleCollectionViewToTopItem()
        }
    }
}
