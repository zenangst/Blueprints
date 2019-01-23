import Cocoa

extension LayoutExampleSceneViewController {

    func configureCollectionView() {
        layoutExampleCollectionView.dataSource = self
        registerCollectionViewItems()
        registerCollectionViewHeaders()
        registerCollectionViewFooters()
    }

    private func registerCollectionViewItems() {
        let layoutExampleItemIdentifier = Constants
            .CollectionViewItemIdentifiers
            .layoutExampleItem
            .rawValue

        layoutExampleCollectionView.register(LayoutExampleCollectionViewItem.self,
                                             forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: layoutExampleItemIdentifier))
    }

    private func registerCollectionViewHeaders() {
        let titleViewElementIdentifier = Constants
            .CollectionViewItemIdentifiers
            .titleViewElement
            .rawValue

        let titleViewElementXib = NSNib(nibNamed: titleViewElementIdentifier,
                                        bundle: nil)

        layoutExampleCollectionView.register(titleViewElementXib,
                                             forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader,
                                             withIdentifier: NSUserInterfaceItemIdentifier(rawValue: titleViewElementIdentifier))
    }

    private func registerCollectionViewFooters() {
        let titleViewElementIdentifier = Constants
            .CollectionViewItemIdentifiers
            .titleViewElement
            .rawValue

        let titleViewElementXib = NSNib(nibNamed: titleViewElementIdentifier,
                                        bundle: nil)

        layoutExampleCollectionView.register(titleViewElementXib,
                                             forSupplementaryViewOfKind: NSCollectionView.elementKindSectionFooter,
                                             withIdentifier: NSUserInterfaceItemIdentifier(rawValue: titleViewElementIdentifier))
    }
}

extension LayoutExampleSceneViewController {

    func configureSceneLayoutTitle() {
        currentBlueprintTitleTextField.stringValue = activeLayout.title
    }

    func configureBluePrintLayout() {
        configureDynamicHeight()
        switch activeLayout {
        case .vertical:
            configureVerticalLayout()
        case .horizontal:
            configureHorizontalLayout()
        case .mosaic:
            configureMosaicLayout()
        }
    }

    private func configureDynamicHeight() {
        dynamicCellSizeCache = [[]]
        if useDynamicHeight {
            layoutExampleCollectionView.delegate = self
        } else {
            layoutExampleCollectionView.delegate = nil
        }
    }
}
