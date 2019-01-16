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

        configureScene {
            // GET DATA
        }
    }

    private func configureScene(completion: () -> Void) {
        view.wantsLayer = true
        configureCollectionView()
        configureBluePrintLayout()
        completion()
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
        let verticalBlueprintLayout = VerticalBlueprintLayout(
            itemsPerRow: 2,//itemsPerRow,
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

        /*NSView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = verticalBlueprintLayout
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }*/
    }
}
