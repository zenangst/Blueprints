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
    @IBOutlet weak var dynamicCellHeightEnabledSwitch: UISwitch!
    @IBOutlet weak var mainScrollViewBottomConstraint: NSLayoutConstraint!

    var interactor: LayoutSettingsSceneBusinessLogic?
    var router: (LayoutSettingsSceneRoutingLogic & LayoutSettingsSceneDataPassing)?

    weak var layoutConfigurationDelegate: LayoutConfigurationDelegate?

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

        if self.isMovingFromParent {
            updateLayoutConfiguration()
        }
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
        setSwitchValues(viewModel: viewModel)
    }
}

private extension LayoutSettingsSceneViewController {

    func updateLayoutConfiguration() {
        let itemsPerRow = CGFloat(itemsPerRowTextField.text)
        let itemsPerCollumn = Int(itemsPerCollumnTextField.text)
        let minimumInteritemSpacing = CGFloat(minimumInteritemSpacingTextField.text)
        let minimumLineSpacing = CGFloat(minimumLineSpacingTextField.text)
        let sectionInsets = UIEdgeInsets(top: topSectionInsetTextField.text,
                                         left: leftSectionInsetTextField.text,
                                         bottom: bottomSectionInsetTextField.text,
                                         right: rightSectionInsetTextField.text)
        let useDynamicHeight = dynamicCellHeightEnabledSwitch.isOn

        let layoutConfiguration = LayoutConfiguration(itemsPerRow: itemsPerRow,
                                                      itemsPerCollumn: itemsPerCollumn,
                                                      minimumInteritemSpacing: minimumInteritemSpacing,
                                                      minimumLineSpacing: minimumLineSpacing,
                                                      sectionInsets: sectionInsets,
                                                      useDynamicHeight: useDynamicHeight)

        layoutConfigurationDelegate?
            .configurationUpdated(configuration: layoutConfiguration)
    }

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

    func setSwitchValues(viewModel: LayoutSettingsScene.GetLayoutConfiguration.ViewModel) {
        dynamicCellHeightEnabledSwitch.isOn = (viewModel.dynamicCellHeightEnabled) ?? (false)
    }

    func setItemsPerRowStepperValue(value: String?) {
        guard let itemsPerRow = Double(value) else {
            return
        }
        itemsPerRowStepper.value = itemsPerRow
    }

    func setItemsPerCollumnStepperValue(value: String?) {
        guard let itemsPerCollumn = Double(value) else {
            return
        }
        itemsPerCollumnStepper.value = itemsPerCollumn
    }

    func setMinimumInteritemSpacingStepperValue(value: String?) {
        guard let minimumInteritemSpacing = Double(value) else {
            return
        }
        minimumInteritemSpacingStepper.value = minimumInteritemSpacing
    }

    func setMinimumLineSpacingStepperValue(value: String?) {
        guard let minimumLineSpacing = Double(value) else {
            return
        }
        minimumLineSpacingStepper.value = minimumLineSpacing
    }

    func setTopSectionInsetStepperValue(value: String?) {
        guard let topSectionInset = Double(value) else {
            return
        }
        topSectionInsetStepper.value = topSectionInset
    }

    func setLeftSectionInsetStepperValue(value: String?) {
        guard let leftSectionInset = Double(value) else {
            return
        }
        leftSectionInsetStepper.value = leftSectionInset
    }

    func setBottomSectionInsetStepperValue(value: String?) {
        guard let bottomSectionInset = Double(value) else {
            return
        }
        bottomSectionInsetStepper.value = bottomSectionInset
    }

    func setRightSectionInsetStepperValue(value: String?) {
        guard let rightSectionInset = Double(value) else {
            return
        }
        rightSectionInsetStepper.value = rightSectionInset
    }
}
