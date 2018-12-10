//
//  LayoutExampleSceneViewController+VerticalMosaicBlueprintLayout.swift
//  Example
//
//  Created by Chris on 10/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import Blueprints
import UIKit

extension LayoutExampleSceneViewController {

    func configureMosaicLayout() {
        let mosaicBlueprintLayout = VerticalMosaicBlueprintLayout(
            itemSize: CGSize.init(width: 50,
                                  height: 400),
            minimumInteritemSpacing: minimumInteritemSpacing,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
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
}
