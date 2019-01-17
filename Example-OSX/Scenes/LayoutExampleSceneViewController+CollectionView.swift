//
//  LayoutExampleSceneViewController+CollectionView.swift
//  Example-OSX
//
//  Created by Chris on 16/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

extension LayoutExampleSceneViewController: NSCollectionViewDataSource {

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        switch activeLayout {
        case .horizontal, .vertical:
            return (exampleDataSource?.count) ?? (0)
        case .mosaic, .waterfall:
            // MARK: - Only supports one section, multiple sections cause overlapping.
            return 1
        }
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return (exampleDataSource?[section].contents?.count) ?? (0)
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return layoutExampleItem(itemForRepresentedObjectAt: indexPath)
    }
}

extension LayoutExampleSceneViewController: NSCollectionViewDelegateFlowLayout {

    /*func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        guard let cachedCellSize = dynamicCellSizeCache[safe: indexPath.section]?[safe: indexPath.item] else {
            let insertedCellSize = addCellSizeToCache(forItemAt: indexPath)
            return insertedCellSize
        }
        return cachedCellSize
    }*/
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
        layoutExampleCollectionViewItem.configure(forExampleContent: exampleDataSource?[indexPath.section].contents?[indexPath.item])
        return layoutExampleCollectionViewItem
    }

    /*func addCellSizeToCache(forItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = layoutExampleCellCalculatedSize(forItemAt: indexPath)
        guard dynamicCellSizeCache[safe: indexPath.section] != nil else {
            dynamicCellSizeCache.append([cellSize])
            return cellSize
        }
        dynamicCellSizeCache[indexPath.section].insert(cellSize, at: indexPath.item)
        return cellSize
    }

    // TODO: - Research into how the implementation differs from iOS as we need to load a dummy cell with the content to get the size.
    func layoutExampleCellCalculatedSize(forItemAt indexPath: IndexPath) -> CGSize {
        let layoutExampleCellIdentifier = Constants
            .CollectionViewItemIdentifiers
            .layoutExampleItem
            .rawValue

        return CGSize(width: 0, height: 0)
    }

    func widthForCellInCurrentLayout() -> CGFloat {
        var cellWidth = layoutExampleCollectionView.frame.size.width - (sectionInsets.left + sectionInsets.right)
        if itemsPerRow > 1 {
            cellWidth -= minimumInteritemSpacing * (itemsPerRow - 1)
        }
        return floor(cellWidth / itemsPerRow)
    }*/
}
