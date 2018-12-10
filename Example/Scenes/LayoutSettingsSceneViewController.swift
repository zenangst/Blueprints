//
//  LayoutSettingsSceneViewController.swift
//  Blueprints
//
//  Created by Chris on 10/12/2018.
//  Copyright (c) 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

protocol LayoutSettingsSceneDisplayLogic: class {

    func presentLayoutConfiguration(viewModel: LayoutSettingsScene.GetLayoutConfiguration.ViewModel)
}

class LayoutSettingsSceneViewController: UIViewController, LayoutSettingsSceneDisplayLogic {

    @IBOutlet weak var itemsPerRowTextField: UITextField!
    @IBOutlet weak var itemsPerCollumnTextField: UITextField!
    @IBOutlet weak var minimumInteritemSpacingTextField: UITextField!
    @IBOutlet weak var minimumLineSpacingTextField: UITextField!
    @IBOutlet weak var topSectionInsetTextField: UITextField!
    @IBOutlet weak var leftSectionInsetTextField: UITextField!
    @IBOutlet weak var bottomSectionInsetTextField: UITextField!
    @IBOutlet weak var rightSectionInsetTextField: UITextField!
    @IBOutlet weak var itemsPerRowStepper: UIStepper!
    @IBOutlet weak var itemsPerCollumnStepper: UIStepper!
    @IBOutlet weak var minimumInteritemSpacingStepper: UIStepper!
    @IBOutlet weak var minimumLineSpacingStepper: UIStepper!
    @IBOutlet weak var topSectionInsetStepper: UIStepper!
    @IBOutlet weak var leftSectionInsetStepper: UIStepper!
    @IBOutlet weak var bottomSectionInsetStepper: UIStepper!
    @IBOutlet weak var rightSectionInsetStepper: UIStepper!
    @IBOutlet weak var mainScrollViewBottomConstraint: NSLayoutConstraint!

    var interactor: LayoutSettingsSceneBusinessLogic?
    var router: (LayoutSettingsSceneRoutingLogic & LayoutSettingsSceneDataPassing)?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
        let viewController = self
        let interactor = LayoutSettingsSceneInteractor()
        let presenter = LayoutSettingsScenePresenter()
        let router = LayoutSettingsSceneRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureScene(completion: {
            getLayoutConfiguration()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeKeyboardObservers()
    }

    private func configureScene(completion: () -> Void) {
        configureNavigationItems()
        configureTextFields()
        completion()
    }
}

extension LayoutSettingsSceneViewController {

    func getLayoutConfiguration() {
        let request = LayoutSettingsScene.GetLayoutConfiguration.Request()
        interactor?.getLayoutConfiguration(request: request)
    }

    func presentLayoutConfiguration(viewModel: LayoutSettingsScene.GetLayoutConfiguration.ViewModel) {
        setTextFieldValues(viewModel: viewModel)
        setStepperValues(viewModel: viewModel)
    }
}

private extension LayoutSettingsSceneViewController {

    func setTextFieldValues(viewModel: LayoutSettingsScene.GetLayoutConfiguration.ViewModel) {
        itemsPerRowTextField.text = viewModel.itemsPerRow
        itemsPerCollumnTextField.text = viewModel.itemsPerCollumn
        minimumInteritemSpacingTextField.text = viewModel.minimumInteritemSpacing
        minimumLineSpacingTextField.text = viewModel.minimumLineSpacing
        topSectionInsetTextField.text = viewModel.topSectionInset
        leftSectionInsetTextField.text = viewModel.leftSectionInset
        bottomSectionInsetTextField.text = viewModel.bottomSectionInset
        rightSectionInsetTextField.text = viewModel.rightSectionInset
    }

    func setStepperValues(viewModel: LayoutSettingsScene.GetLayoutConfiguration.ViewModel) {
        setItemsPerRowStepperValue(value: viewModel.itemsPerRow)
        setItemsPerCollumnStepperValue(value: viewModel.itemsPerCollumn)
        setMinimumInteritemSpacingStepperValue(value: viewModel.minimumInteritemSpacing)
        setMinimumLineSpacingStepperValue(value: viewModel.minimumLineSpacing)
        setTopSectionInsetStepperValue(value: viewModel.topSectionInset)
        setLeftSectionInsetStepperValue(value: viewModel.leftSectionInset)
        setBottomSectionInsetStepperValue(value: viewModel.bottomSectionInset)
        setRightSectionInsetStepperValue(value: viewModel.rightSectionInset)
    }

    func setItemsPerRowStepperValue(value: String?) {
        if let itemsPerRow = value,
            let itemsPerRowDouble = Double(itemsPerRow) {
            itemsPerRowStepper.value = itemsPerRowDouble
        }
    }

    func setItemsPerCollumnStepperValue(value: String?) {
        if let itemsPerCollumn = value,
            let itemsPerCollumnDouble = Double(itemsPerCollumn) {
            itemsPerCollumnStepper.value = itemsPerCollumnDouble
        }
    }

    func setMinimumInteritemSpacingStepperValue(value: String?) {
        if let minimumInteritemSpacing = value,
            let minimumInteritemSpacingDouble = Double(minimumInteritemSpacing) {
            minimumInteritemSpacingStepper.value = minimumInteritemSpacingDouble
        }
    }

    func setMinimumLineSpacingStepperValue(value: String?) {
        if let minimumLineSpacing = value,
            let minimumLineSpacingDouble = Double(minimumLineSpacing) {
            minimumLineSpacingStepper.value = minimumLineSpacingDouble
        }
    }

    func setTopSectionInsetStepperValue(value: String?) {
        if let topSectionInset = value,
            let topSectionInsetDouble = Double(topSectionInset) {
            topSectionInsetStepper.value = topSectionInsetDouble
        }
    }

    func setLeftSectionInsetStepperValue(value: String?) {
        if let leftSectionInset = value,
            let leftSectionInsetDouble = Double(leftSectionInset) {
            leftSectionInsetStepper.value = leftSectionInsetDouble
        }
    }

    func setBottomSectionInsetStepperValue(value: String?) {
        if let bottomSectionInset = value,
            let bottomSectionInsetDouble = Double(bottomSectionInset) {
            bottomSectionInsetStepper.value = bottomSectionInsetDouble
        }
    }

    func setRightSectionInsetStepperValue(value: String?) {
        if let rightSectionInset = value,
            let rightSectionInsetDouble = Double(rightSectionInset) {
            rightSectionInsetStepper.value = rightSectionInsetDouble
        }
    }
}
