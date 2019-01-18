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
}

class LayoutExampleSceneViewController: NSViewController, LayoutExampleSceneDisplayLogic {

    @IBOutlet weak var layoutExampleCollectionView: NSCollectionView!
    // TODO: - Remove if this is unused.
    @IBOutlet weak var collectionViewContainerViewWidthConstraint: NSLayoutConstraint!

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
}
