import UIKit

extension LayoutExampleSceneViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (exampleDataSource?.count) ?? (0)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (exampleDataSource?[section].contents?.count) ?? (0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return layoutExampleCell(forItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return headerTitleCollectionReusableView(forItemAt: indexPath)
        case UICollectionView.elementKindSectionFooter:
            return footerTitleCollectionReusableView(forItemAt: indexPath)
        default:
            return UICollectionReusableView()
        }
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section % 2 == 1 ?
            CGSize(width: collectionView.frame.width, height: 122)
            :
            CGSize(width: collectionView.frame.width, height: 61)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section % 2 == 1 ?
            CGSize(width: collectionView.frame.width, height: 122)
            :
            CGSize(width: collectionView.frame.width, height: 61)
    }
}

private extension LayoutExampleSceneViewController {

    func headerTitleCollectionReusableView(forItemAt indexPath: IndexPath) -> TitleCollectionReusableView {
        let titleCellIdentifier = Constants
            .CollectionViewCellIdentifiers
            .titleReusableView
            .rawValue
        guard let titleCollectionReusableView = layoutExampleCollectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: titleCellIdentifier,
            for: indexPath) as? TitleCollectionReusableView else {
                fatalError("Failed to dequeue UICollectionReusableView for indexPath: \(indexPath)")
        }
        let title = "\((exampleDataSource?[indexPath.section].title) ?? ("Section")) Header"
        titleCollectionReusableView.configure(withTitle: title)
        return titleCollectionReusableView
    }

    func footerTitleCollectionReusableView(forItemAt indexPath: IndexPath) -> TitleCollectionReusableView {
        let titleCellIdentifier = Constants
            .CollectionViewCellIdentifiers
            .titleReusableView
            .rawValue
        guard let titleCollectionReusableView = layoutExampleCollectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: titleCellIdentifier,
            for: indexPath) as? TitleCollectionReusableView else {
                fatalError("Failed to dequeue UICollectionReusableView for indexPath: \(indexPath)")
        }
        let title = "\((exampleDataSource?[indexPath.section].title) ?? ("Section")) Footer"
        titleCollectionReusableView.configure(withTitle: title)
        return titleCollectionReusableView
    }

    func layoutExampleCell(forItemAt indexPath: IndexPath) -> LayoutExampleCollectionViewCell {
        let layoutExampleCellIdentifier = Constants
            .CollectionViewCellIdentifiers
            .layoutExampleCell
            .rawValue
        guard let layoutExampleCell = layoutExampleCollectionView.dequeueReusableCell(
            withReuseIdentifier: layoutExampleCellIdentifier,
            for: indexPath) as? LayoutExampleCollectionViewCell else {
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
