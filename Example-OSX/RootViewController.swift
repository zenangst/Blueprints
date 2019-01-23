import Cocoa

class RootViewController: NSViewController {

    private var current: NSViewController

    init<T: NSViewController>(withNibName nibName: String, controllerType: T.Type) {
        let controller = T(nibName: nibName, bundle: nil)
        current = controller

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        self.view = NSView()
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        addCurrentView()
    }
}

private extension RootViewController {

    func addCurrentView() {
        view.addSubview(current.view)
        configureCurrentViewsConstraints()
    }

    func configureCurrentViewsConstraints() {
        current.view.translatesAutoresizingMaskIntoConstraints = false
        current.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        current.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        current.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        current.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}
