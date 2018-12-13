//
//  LayoutExampleSceneViewController+CollectionView.swift
//  Example
//
//  Created by Chris on 06/12/2018.
//  Copyright © 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

extension LayoutExampleSceneViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch activeLayout {
        case .horizontal, .vertical:
            return (exampleDataSource?.count) ?? (0)
        case .mosaic, .waterfall:
            // MARK: - Only supports one section, multiple sections cause overlapping.
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (exampleDataSource?[section].contents?.count) ?? (0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return layoutExampleCell(forItemAt: indexPath)
    }
}

extension LayoutExampleSceneViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cachedCellSize = dynamicCellSizeCache[safe: indexPath.section]?[safe: indexPath.row] else {
            let insertedCellSize = addCellSizeToCache(forItemAt: indexPath)
            return insertedCellSize
        }
        return cachedCellSize
    }
}

private extension LayoutExampleSceneViewController {

    func layoutExampleCell(forItemAt indexPath: IndexPath) -> LayoutExampleCollectionViewCell {
        let layoutExampleCellIdentifier = Constants
            .CollectionViewCellIdentifiers
            .layoutExampleCell
            .rawValue
        guard let layoutExampleCell = layoutExampleCollectionView.dequeueReusableCell(withReuseIdentifier: layoutExampleCellIdentifier, for: indexPath) as? LayoutExampleCollectionViewCell else {
            fatalError("Failed to dequeue cell at indexPath: \(indexPath)")
        }
        layoutExampleCell.configure(forExampleContent: exampleDataSource?[indexPath.section].contents?[indexPath.row])
        return layoutExampleCell
    }

    func addCellSizeToCache(forItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = layoutExampleCellCalculatedSize(forItemAt: indexPath)
        guard dynamicCellSizeCache[safe: indexPath.section] != nil else {
            dynamicCellSizeCache.append([cellSize])
            return cellSize
        }
        dynamicCellSizeCache[indexPath.section].insert(cellSize, at: indexPath.row)
        return cellSize
    }

    func layoutExampleCellCalculatedSize(forItemAt indexPath: IndexPath) -> CGSize {
        let layoutExampleCellIdentifier = Constants
            .CollectionViewCellIdentifiers
            .layoutExampleCell
            .rawValue
        guard let layoutExampleCellForSize = Bundle.main.loadNibNamed(layoutExampleCellIdentifier, owner: self, options: nil)?.first as? LayoutExampleCollectionViewCell else {
            fatalError("Failed to load Xib from bundle named: \(layoutExampleCellIdentifier)")
        }
        layoutExampleCellForSize.configure(forExampleContent: exampleDataSource?[indexPath.section].contents?[indexPath.row])
        layoutExampleCellForSize.setNeedsLayout()
        layoutExampleCellForSize.layoutIfNeeded()
        let cellWidth = widthForCellInCurrentLayout()
        let cellHeight: CGFloat = 0
        let cellTargetSize = CGSize(width: cellWidth,
                                    height: cellHeight)
        let cellSize = layoutExampleCellForSize.contentView.systemLayoutSizeFitting(cellTargetSize,
                                                                                    withHorizontalFittingPriority: .defaultHigh,
                                                                                    verticalFittingPriority: .fittingSizeLevel)
        return cellSize
    }

    func widthForCellInCurrentLayout() -> CGFloat {
        var cellWidth = layoutExampleCollectionView.frame.size.width - (sectionInsets.left + sectionInsets.right)
        if itemsPerRow > 1 {
            cellWidth -= minimumInteritemSpacing * (itemsPerRow - 1)
        }
        return floor(cellWidth / itemsPerRow)
    }
}
