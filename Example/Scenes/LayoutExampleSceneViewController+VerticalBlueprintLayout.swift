//
//  LayoutExampleSceneViewController+VerticalBlueprintLayout.swift
//  Example
//
//  Created by Chris on 10/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import Blueprints
import UIKit

extension LayoutExampleSceneViewController {

    func configureVerticalLayout() {
        let verticalBlueprintLayout = VerticalBlueprintLayout(
            itemsPerRow: itemsPerRow,
            itemSize: CGSize(width: 200,
                             height: 95),
            minimumInteritemSpacing: minimumInteritemSpacing,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
            stickyHeaders: true,
            stickyFooters: true
        )
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = verticalBlueprintLayout
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
    }
}
