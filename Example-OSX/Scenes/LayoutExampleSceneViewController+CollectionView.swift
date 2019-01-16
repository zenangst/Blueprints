//
//  LayoutExampleSceneViewController+CollectionView.swift
//  Example-OSX
//
//  Created by Chris on 16/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

extension LayoutExampleSceneViewController: NSCollectionViewDataSource {

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return layoutExampleItem(itemForRepresentedObjectAt: indexPath)
    }
}

private extension LayoutExampleSceneViewController {

    func layoutExampleItem(itemForRepresentedObjectAt indexPath: IndexPath) -> LayoutExampleCollectionViewItem {
        let layoutExampleCellIdentifier = Constants
            .CollectionViewItemIdentifiers
            .layoutExampleItem
            .rawValue
        guard let layoutExampleCollectionViewItem = layoutExampleCollectionView.makeItem(
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: layoutExampleCellIdentifier),
            for: indexPath) as? LayoutExampleCollectionViewItem else {
                fatalError("Failed to makeItem at indexPath \(indexPath)")
        }
        // TODO: - Complete implementation
        //layoutExampleCollectionViewItem.configure(forExampleContent: exampleDataSource?[indexPath.section].contents?[indexPath.row])
        return layoutExampleCollectionViewItem
    }
}
