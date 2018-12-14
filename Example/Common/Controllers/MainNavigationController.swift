import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }
}

private extension MainNavigationController {

    func configureNavigationBar() {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .blueprintsBlue
        navigationBar.backgroundColor = .blueprintsBlue
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.barTintColor = UIColor(patternImage: #imageLiteral(resourceName: "Blueprints-background"))
    }
}
