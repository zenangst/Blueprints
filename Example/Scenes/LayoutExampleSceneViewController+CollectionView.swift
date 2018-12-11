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
            // MARK: - Only supports one section multiple sections cause overlapping.
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

// TODO: - Implement this to showcase dynamic heights for layouts that support this.
extension LayoutExampleSceneViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layoutExampleCellIdentifier = Constants
            .CollectionViewCellIdentifiers
            .layoutExampleCell
            .rawValue
        guard let layoutExampleCell = layoutExampleCollectionView.dequeueReusableCell(withReuseIdentifier: layoutExampleCellIdentifier, for: indexPath) as? LayoutExampleCollectionViewCell else {
            fatalError("Failed to dequeue cell at indexPath: \(indexPath)")
        }
        layoutExampleCell.configure(forExampleContent: exampleDataSource?[indexPath.section].contents?[indexPath.row])
        layoutExampleCell.setNeedsLayout()
        layoutExampleCell.layoutIfNeeded()

        let cellWidth = widthForCellInCurrentLayout()
        let cellHeight: CGFloat = 0
        let cellTargetSize = CGSize(width: cellWidth, height: cellHeight)
        let cellSize = layoutExampleCell.contentView.systemLayoutSizeFitting(cellTargetSize,
                                                                             withHorizontalFittingPriority: .defaultHigh,
                                                                             verticalFittingPriority: .fittingSizeLevel)

        return cellSize
    }

    private func widthForCellInCurrentLayout() -> CGFloat {
        var cellWidth = layoutExampleCollectionView.frame.size.width
        if itemsPerRow > 1 {
            cellWidth -= minimumInteritemSpacing * (itemsPerRow - 1)
        }
        return floor(cellWidth / itemsPerRow)
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
}
