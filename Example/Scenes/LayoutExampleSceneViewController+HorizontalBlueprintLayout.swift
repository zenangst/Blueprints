//
//  LayoutExampleSceneViewController+HorizontalBlueprintLayout.swift
//  Example
//
//  Created by Chris on 10/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import Blueprints
import UIKit

extension LayoutExampleSceneViewController {

    func configureHorizontalLayout() {
        let horizontalBlueprintLayout = HorizontalBlueprintLayout(
            itemsPerRow: itemsPerRow + 0.1,
            itemsPerColumn: itemsPerColumn,
            itemSize: CGSize(width: 200,
                             height: 95),
            minimumInteritemSpacing: minimumInteritemSpacing,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
            stickyHeaders: true,
            stickyFooters: true
        )
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = horizontalBlueprintLayout
            self?.layoutExampleCollectionView.contentOffset.x = 0
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
            self?.navigationController?.navigationBar.sizeToFit()
        }
    }
}
