import UIKit

protocol LayoutExampleSceneDisplayLogic: class {

    func displayExampleData(viewModel: LayoutExampleScene.GetExampleData.ViewModel)
}

class LayoutExampleSceneViewController: UIViewController, LayoutExampleSceneDisplayLogic {

    @IBOutlet weak var layoutExampleCollectionView: UICollectionView!

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
    var router: (LayoutExampleSceneRoutingLogic & LayoutExampleSceneDataPassing)?

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
        let interactor = LayoutExampleSceneInteractor()
        let presenter = LayoutExampleScenePresenter()
        let router = LayoutExampleSceneRouter()
        let worker = LayoutExampleSceneWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureScene(completion: {
            getExampleData()
        })
    }

    private func configureScene(completion: () -> Void) {
        configureNavigationController()
        configureNavigationItems()
        configureControllerTitle()
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

extension LayoutExampleSceneViewController: LayoutConfigurationDelegate {

    func configurationUpdated(configuration: LayoutConfiguration) {
        if currentConfiguration != configuration {
            currentConfiguration = configuration
            self.itemsPerRow = (configuration.itemsPerRow) ?? (Constants.ExampleLayoutDefaults.itemsPerRow)
            self.itemsPerColumn = (configuration.itemsPerCollumn) ?? (Constants.ExampleLayoutDefaults.itemsPerColumn)
            self.minimumInteritemSpacing = (configuration.minimumInteritemSpacing) ?? (Constants.ExampleLayoutDefaults.minimumInteritemSpacing)
            self.minimumLineSpacing = (configuration.minimumLineSpacing) ?? (Constants.ExampleLayoutDefaults.minimumLineSpacing)
            self.sectionInsets = (configuration.sectionInsets) ?? (Constants.ExampleLayoutDefaults.sectionInsets)
            self.useDynamicHeight = (configuration.useDynamicHeight) ?? (Constants.ExampleLayoutDefaults.useDynamicHeight)
            configureBluePrintLayout()
        }
    }
}
