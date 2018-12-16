import UIKit

extension LayoutSettingsSceneViewController {

    func configureNavigationItems() {
        configureLargeTitles()
    }

    private func configureLargeTitles() {
        navigationItem.largeTitleDisplayMode = .never
    }
}

extension LayoutSettingsSceneViewController {

    func configureTextFields() {
        configureInputAccessoryView(on: itemsPerRowTextField)
        configureInputAccessoryView(on: itemsPerCollumnTextField)
        configureInputAccessoryView(on: minimumInteritemSpacingTextField)
        configureInputAccessoryView(on: minimumLineSpacingTextField)
        configureInputAccessoryView(on: topSectionInsetTextField)
        configureInputAccessoryView(on: leftSectionInsetTextField)
        configureInputAccessoryView(on: bottomSectionInsetTextField)
        configureInputAccessoryView(on: rightSectionInsetTextField)
    }

    private func configureInputAccessoryView(on textfield: UITextField) {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = false
        toolbar.barTintColor = .blueprintsBlue
        toolbar.backgroundColor = .blueprintsBlue
        toolbar.tintColor = .white
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: textfield,
                                         action: #selector(endEditing(_:)))

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                            target: nil,
                                            action: nil)

        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        textfield.inputAccessoryView = toolbar
    }

    @objc
    private func endEditing(_ sender: UITextField) {
        sender.endEditing(true)
    }
}
