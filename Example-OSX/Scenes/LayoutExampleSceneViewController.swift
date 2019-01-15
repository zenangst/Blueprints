//
//  LayoutExampleSceneViewController.swift
//  Example-OSX
//
//  Created by Chris on 15/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Blueprints
import Cocoa

class LayoutExampleSceneViewController: NSViewController {

    @IBOutlet weak var layoutExampleCollectionView: NSCollectionView!

    var activeLayout: BlueprintLayout = .vertical
    var dynamicCellSizeCache: [[CGSize]] = [[]]
    var useDynamicHeight = false
    var itemsPerRow = Constants.ExampleLayoutDefaults.itemsPerRow
    var itemsPerColumn = Constants.ExampleLayoutDefaults.itemsPerColumn
    var minimumInteritemSpacing = Constants.ExampleLayoutDefaults.minimumInteritemSpacing
    var minimumLineSpacing = Constants.ExampleLayoutDefaults.minimumLineSpacing
    var sectionInsets = Constants.ExampleLayoutDefaults.sectionInsets

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: - Move inside completionHandler method
        configureCollectionView()
        configureBluePrintLayout()
    }

    override func viewWillAppear() {
        super.viewWillAppear()

    }

    override func viewDidAppear() {
        super.viewDidAppear()

    }
}

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

// TODO: - Move to seperate file
private extension LayoutExampleSceneViewController {

    func configureCollectionView() {
        layoutExampleCollectionView.dataSource = self
        registerCollectionViewItems()
    }

    func registerCollectionViewItems() {
        let layoutExampleItemIdentifier = Constants
            .CollectionViewItemIdentifiers
            .layoutExampleItem
            .rawValue

        layoutExampleCollectionView.register(LayoutExampleCollectionViewItem.self,
                                forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: layoutExampleItemIdentifier))
    }
}

// TODO: - Move to seperate file
private extension LayoutExampleSceneViewController {

    func configureBluePrintLayout() {
        configureDynamicHeight()
        switch activeLayout {
        case .vertical:
            configureVerticalLayout()
        case .horizontal:
            return
            //configureHorizontalLayout()
        case .mosaic:
            return
            //configureMosaicLayout()
        case .waterfall:
            return
            //configureWaterFallLayout()
        }
    }

    private func configureDynamicHeight() {
        dynamicCellSizeCache = [[]]
        if useDynamicHeight {
            //layoutExampleCollectionView.delegate = self
        } else {
            layoutExampleCollectionView.delegate = nil
        }
    }
}

// TODO: - Move to seperate file
extension LayoutExampleSceneViewController {

    func configureVerticalLayout() {
        let verticalBlueprintLayout = HorizontalBlueprintLayout(
            itemsPerRow: itemsPerRow,
            height: 95,
            minimumInteritemSpacing: minimumInteritemSpacing,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
            stickyHeaders: true,
            stickyFooters: true
        )

        //let titleCollectionReusableViewSize = CGSize(width: view.bounds.width, height: 61)
        //verticalBlueprintLayout.headerReferenceSize = titleCollectionReusableViewSize
        //verticalBlueprintLayout.footerReferenceSize = titleCollectionReusableViewSize

        layoutExampleCollectionView.collectionViewLayout = verticalBlueprintLayout
        view.layout()

        /*NSView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = verticalBlueprintLayout
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }*/
    }
}
