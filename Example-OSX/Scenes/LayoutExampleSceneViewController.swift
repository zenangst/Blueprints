//
//  LayoutExampleSceneViewController.swift
//  Example-OSX
//
//  Created by Chris on 15/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

import Cocoa

protocol LayoutExampleSceneDisplayLogic: class {

    func displayExampleData(viewModel: LayoutExampleScene.GetExampleData.ViewModel)
    func presentLayoutConfiguration(viewModel: LayoutExampleScene.GetLayoutConfiguration.ViewModel)
}

class LayoutExampleSceneViewController: NSViewController, LayoutExampleSceneDisplayLogic {

    // MARK: - Title
    @IBOutlet weak var currentBlueprintTitleTextField: NSTextField!
    // TODO: - Remove if unused.
    @IBOutlet weak var previousBlueprintButton: NSButton!
    @IBOutlet weak var nextBlueprintButton: NSButton!
    // MARK: - Settings
    @IBOutlet weak var layoutExampleCollectionView: NSCollectionView!
    @IBOutlet weak var itemsPerRowTextField: NSTextField!
    @IBOutlet weak var itemsPerCollumnTextField: NSTextField!
    @IBOutlet weak var minimumInterItemSpacingTextField: NSTextField!
    @IBOutlet weak var minimumLineSpacingTextField: NSTextField!
    @IBOutlet weak var sectionInsetTopTextField: NSTextField!
    @IBOutlet weak var sectionInsetLeftTextField: NSTextField!
    @IBOutlet weak var sectionInsetBottomTextField: NSTextField!
    @IBOutlet weak var sectionInsetRightTextField: NSTextField!
    @IBOutlet weak var applyConfigurationButton: NSButton!
    // TODO: - Remove if this is unused.
    @IBOutlet weak var collectionViewContainerViewWidthConstraint: NSLayoutConstraint!

    // TODO: - To move to own file
    // ACTIONS:
    @IBAction func previousButtonDidClick(_ sender: Any) {
        activeLayout.switchToPreviousLayout()
        configureBluePrintLayout()
        // TODO: - Move to config
        currentBlueprintTitleTextField.stringValue = activeLayout.title
    }

    @IBAction func nextButtonDidClick(_ sender: Any) {
        activeLayout.switchToNextLayout()
        configureBluePrintLayout()
        // TODO: - Move to config
        currentBlueprintTitleTextField.stringValue = activeLayout.title
    }

    @IBAction func applyButtonDidClick(_ sender: Any) {
        let currentLayoutConfiguration = currentlayoutConfiguration()
        if currentConfiguration != currentLayoutConfiguration {
            currentConfiguration = currentLayoutConfiguration
            itemsPerRow = (currentConfiguration?.itemsPerRow) ?? (Constants.ExampleLayoutDefaults.itemsPerRow)
            itemsPerColumn = (currentConfiguration?.itemsPerCollumn) ?? (Constants.ExampleLayoutDefaults.itemsPerColumn)
            minimumLineSpacing = (currentConfiguration?.minimumLineSpacing) ?? (Constants.ExampleLayoutDefaults.minimumLineSpacing)
            sectionInsets = (currentConfiguration?.sectionInsets) ?? (Constants.ExampleLayoutDefaults.sectionInsets)
            configureBluePrintLayout()
        }
    }

    var exampleDataSource: [LayoutExampleScene.GetExampleData.ViewModel.DisplayedExampleSection]?
    var activeLayout: BlueprintLayout = .vertical
    var dynamicCellSizeCache: [[CGSize]] = [[]]
    var useDynamicHeight = false
    var itemsPerRow = Constants.ExampleLayoutDefaults.itemsPerRow
    var itemsPerColumn = Constants.ExampleLayoutDefaults.itemsPerColumn
    var minimumInteritemSpacing = Constants.ExampleLayoutDefaults.minimumInteritemSpacing
    var minimumLineSpacing = Constants.ExampleLayoutDefaults.minimumLineSpacing
    var sectionInsets = Constants.ExampleLayoutDefaults.sectionInsets
    var currentConfiguration: LayoutConfiguration?

    var interactor: LayoutExampleSceneBusinessLogic?

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    private func setup() {
        let viewController = self
        let interactor = LayoutExampleSceneInteractor()
        let presenter = LayoutExampleScenePresenter()
        let worker = LayoutExampleSceneWorker()
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureScene {
            getExampleData()
            getLayoutConfiguration()
        }
    }

    private func configureScene(completion: () -> Void) {
        view.wantsLayer = true
        configureCollectionView()
        configureBluePrintLayout()
        completion()
    }
}

extension LayoutExampleSceneViewController {

    func getExampleData() {
        let request = LayoutExampleScene.GetExampleData.Request(numberOfSections: 2,
                                                                numberOfRowsInSection: 20)
        interactor?.getExampleData(request: request)
    }

    func displayExampleData(viewModel: LayoutExampleScene.GetExampleData.ViewModel) {
        exampleDataSource = viewModel.displayedExampleSections
        layoutExampleCollectionView.reloadData()
    }

    func getLayoutConfiguration() {
        let request = LayoutExampleScene.GetLayoutConfiguration.Request()
        interactor?.getLayoutConfiguration(request: request)
    }

    func presentLayoutConfiguration(viewModel: LayoutExampleScene.GetLayoutConfiguration.ViewModel) {
        setInitialLayoutConfiguration(viewModel: viewModel)
        setInitialTextFieldValues(viewModel: viewModel)
    }
}

private extension LayoutExampleSceneViewController {

    func setInitialLayoutConfiguration(viewModel: LayoutExampleScene.GetLayoutConfiguration.ViewModel) {
        let itemsPerRow = CGFloat(viewModel.itemsPerRow)
        let itemsPerCollumn = Int(viewModel.itemsPerCollumn)
        let minimumInteritemSpacing = CGFloat(viewModel.minimumInteritemSpacing)
        let minimumLineSpacing = CGFloat(viewModel.minimumLineSpacing)
        let sectionInsets = NSEdgeInsets(top: viewModel.topSectionInset,
                                         left: viewModel.leftSectionInset,
                                         bottom: viewModel.bottomSectionInset,
                                         right: viewModel.rightSectionInset)
        let useDynamicHeight = viewModel.dynamicCellHeightEnabled

        let layoutConfiguration = LayoutConfiguration(itemsPerRow: itemsPerRow,
                                                      itemsPerCollumn: itemsPerCollumn,
                                                      minimumInteritemSpacing: minimumInteritemSpacing,
                                                      minimumLineSpacing: minimumLineSpacing,
                                                      sectionInsets: sectionInsets,
                                                      useDynamicHeight: useDynamicHeight)

        currentConfiguration = layoutConfiguration
    }

    func setInitialTextFieldValues(viewModel: LayoutExampleScene.GetLayoutConfiguration.ViewModel) {
        let nilValueReplacement = ""
        itemsPerRowTextField.stringValue = (viewModel.itemsPerRow) ?? (nilValueReplacement)
        itemsPerCollumnTextField.stringValue = (viewModel.itemsPerCollumn) ?? (nilValueReplacement)
        minimumInterItemSpacingTextField.stringValue = (viewModel.minimumInteritemSpacing) ?? (nilValueReplacement)
        minimumLineSpacingTextField.stringValue = (viewModel.minimumLineSpacing) ?? (nilValueReplacement)
        sectionInsetTopTextField.stringValue = (viewModel.topSectionInset) ?? (nilValueReplacement)
        sectionInsetLeftTextField.stringValue = (viewModel.leftSectionInset) ?? (nilValueReplacement)
        sectionInsetBottomTextField.stringValue = (viewModel.bottomSectionInset) ?? (nilValueReplacement)
        sectionInsetRightTextField.stringValue = (viewModel.rightSectionInset) ?? (nilValueReplacement)
    }

    func currentlayoutConfiguration() -> LayoutConfiguration {
        let itemsPerRow = CGFloat(itemsPerRowTextField.stringValue)
        let itemsPerCollumn = Int(itemsPerCollumnTextField.stringValue)
        let minimumInteritemSpacing = CGFloat(minimumInterItemSpacingTextField.stringValue)
        let minimumLineSpacing = CGFloat(minimumLineSpacingTextField.stringValue)
        let sectionInsets = NSEdgeInsets(top: sectionInsetTopTextField.stringValue,
                                         left: sectionInsetLeftTextField.stringValue,
                                         bottom: sectionInsetBottomTextField.stringValue,
                                         right: sectionInsetRightTextField.stringValue)

        // TODO: - Update this value once we have implemented dynamic heights.
        let useDynamicHeight = false

        let layoutConfiguration = LayoutConfiguration(itemsPerRow: itemsPerRow,
                                                      itemsPerCollumn: itemsPerCollumn,
                                                      minimumInteritemSpacing: minimumInteritemSpacing,
                                                      minimumLineSpacing: minimumLineSpacing,
                                                      sectionInsets: sectionInsets,
                                                      useDynamicHeight: useDynamicHeight)

        return layoutConfiguration
    }
}
