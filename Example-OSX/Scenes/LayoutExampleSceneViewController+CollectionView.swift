import Cocoa

extension LayoutExampleSceneViewController: NSCollectionViewDataSource {

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return (exampleDataSource?.count) ?? (0)
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return (exampleDataSource?[section].contents?.count) ?? (0)
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return layoutExampleItem(itemForRepresentedObjectAt: indexPath)
    }

    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        switch kind {
        case NSCollectionView.elementKindSectionHeader:
            return headerTitleCollectionViewElement(forItemAt: indexPath)
        case NSCollectionView.elementKindSectionFooter:
            return footerTitleCollectionViewElement(forItemAt: indexPath)
        default:
            return NSView()
        }
    }

    // TODO: - Update this once we have implemented dynamic heights.
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return headerTitleCollectionReusableView(forItemAt: indexPath)
        case UICollectionView.elementKindSectionFooter:
            return footerTitleCollectionReusableView(forItemAt: indexPath)
        default:
            return UICollectionReusableView()
        }
    }*/
}

extension LayoutExampleSceneViewController: NSCollectionViewDelegateFlowLayout {

    // TODO: - Update this value once we have implemented dynamic heights.
    /*func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        guard let cachedCellSize = dynamicCellSizeCache[safe: indexPath.section]?[safe: indexPath.item] else {
            let insertedCellSize = addCellSizeToCache(forItemAt: indexPath)
            return insertedCellSize
        }
        return cachedCellSize
    }*/
}

extension LayoutExampleSceneViewController {

    private func headerTitleCollectionViewElement(forItemAt indexPath: IndexPath) -> TitleCollectionViewElement {
        let titleViewElementIdentifier = Constants
            .CollectionViewItemIdentifiers
            .titleViewElement
            .rawValue
        guard let titleViewElementView = layoutExampleCollectionView.makeSupplementaryView(
            ofKind: NSCollectionView.elementKindSectionHeader,
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: titleViewElementIdentifier),
            for: indexPath) as? TitleCollectionViewElement else {
                fatalError("Failed to makeItem at indexPath \(indexPath)")
        }
        let title = "\((exampleDataSource?[indexPath.section].title) ?? ("Section")) Header"
        titleViewElementView.configure(withTitle: title)
        return titleViewElementView
    }

    private func footerTitleCollectionViewElement(forItemAt indexPath: IndexPath) -> TitleCollectionViewElement {
        let titleViewElementIdentifier = Constants
            .CollectionViewItemIdentifiers
            .titleViewElement
            .rawValue
        guard let titleViewElementView = layoutExampleCollectionView.makeSupplementaryView(
            ofKind: NSCollectionView.elementKindSectionFooter,
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: titleViewElementIdentifier),
            for: indexPath) as? TitleCollectionViewElement else {
                fatalError("Failed to makeItem at indexPath \(indexPath)")
        }
        let title = "\((exampleDataSource?[indexPath.section].title) ?? ("Section")) Footer"
        titleViewElementView.configure(withTitle: title)
        return titleViewElementView
    }

    private func layoutExampleItem(itemForRepresentedObjectAt indexPath: IndexPath) -> LayoutExampleCollectionViewItem {
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

    // TODO: - Update this value once we have implemented dynamic heights.
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
    // - Cant use makeItem as the collectionView has not been finalised at this time.
    func layoutExampleCellCalculatedSize(forItemAt indexPath: IndexPath) -> CGSize {
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
        return layoutExampleCollectionViewItem.view.fittingSize
    }

    func widthForCellInCurrentLayout() -> CGFloat {
        var cellWidth = layoutExampleCollectionView.frame.size.width - (sectionInsets.left + sectionInsets.right)
        if itemsPerRow > 1 {
            cellWidth -= minimumInteritemSpacing * (itemsPerRow - 1)
        }
        return floor(cellWidth / itemsPerRow)
    }*/

    func scrollLayoutExampleCollectionViewToTopItem() {
        let initalIndexPath = IndexPath(item: 0, section: 0)
        if let sectionHeader = layoutExampleCollectionView.supplementaryView(
            forElementKind: NSCollectionView.elementKindSectionHeader,
            at: initalIndexPath) {
            layoutExampleCollectionView.scrollToVisible(
                NSRect(x: sectionHeader.bounds.origin.x,
                       y: sectionHeader.bounds.origin.y,
                       width: sectionHeader.bounds.width,
                       height: sectionHeader.bounds.height))
        } else if layoutExampleCollectionView.item(at: initalIndexPath) != nil {
            layoutExampleCollectionView.scrollToItems(
                at: [initalIndexPath],
                scrollPosition: NSCollectionView.ScrollPosition.top)
        }
    }
}
