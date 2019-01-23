import UIKit

extension LayoutExampleSceneViewController {

    func configureControllerTitle() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.title = self?.activeLayout.title
        }
    }

    func configureNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureNavigationItems() {
        configureSettingsButton()
        configureNextLayoutButton()
    }

    private func configureSettingsButton() {
        let settingsButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                             target: self,
                                             action: #selector(routeToSettingsScene))
        navigationItem.leftBarButtonItem = settingsButton
    }

    private func configureNextLayoutButton() {
        let nextLayoutButton = UIBarButtonItem(barButtonSystemItem: .fastForward,
                                               target: self,
                                               action: #selector(configureNextLayout))
        navigationItem.rightBarButtonItem = nextLayoutButton
    }

    @objc
    private func routeToSettingsScene() {
        router?.routeToLayoutSettingsScene()
    }

    @objc
    private func configureNextLayout() {
        activeLayout.switchToNextLayout()
        configureBluePrintLayout()
        configureControllerTitle()
    }
}

extension LayoutExampleSceneViewController {

    func configureCollectionView() {
        layoutExampleCollectionView.dataSource = self
        registerCollectionViewCells()
        registerCollectionViewHeaders()
        registerCollectionViewFooters()
    }

    private func registerCollectionViewCells() {
        let layoutExampleCellIdentifier = Constants
            .CollectionViewCellIdentifiers
            .layoutExampleCell
            .rawValue

        let layoutExampleCellXib = UINib(nibName: layoutExampleCellIdentifier,
                                         bundle: nil)

        layoutExampleCollectionView.register(layoutExampleCellXib,
                                             forCellWithReuseIdentifier: layoutExampleCellIdentifier)
    }

    private func registerCollectionViewHeaders() {
        let titleCellIdentifier = Constants
            .CollectionViewCellIdentifiers
            .titleReusableView
            .rawValue

        let titleCellXib = UINib(nibName: titleCellIdentifier,
                                 bundle: nil)

        layoutExampleCollectionView?.register(titleCellXib,
                                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                              withReuseIdentifier: titleCellIdentifier)
    }

    private func registerCollectionViewFooters() {
        let titleCellIdentifier = Constants
            .CollectionViewCellIdentifiers
            .titleReusableView
            .rawValue

        let titleCellXib = UINib(nibName: titleCellIdentifier,
                                 bundle: nil)

        layoutExampleCollectionView?.register(titleCellXib,
                                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                              withReuseIdentifier: titleCellIdentifier)
    }
}

extension LayoutExampleSceneViewController {

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
