import UIKit

extension LayoutSettingsSceneViewController {

    @IBAction
    func itemsPerRowStepperValueChanged(_ sender: Any) {
        guard let stepper = sender as? UIStepper else {
            return
        }
        let oneDecimalPlacesFormat = "%.1f"
        itemsPerRowTextField.text = String(format: oneDecimalPlacesFormat, stepper.value)
    }

    @IBAction
    func itemsPerCollumnStepperValueChanged(_ sender: Any) {
        guard let stepper = sender as? UIStepper else {
            return
        }
        let noDecimalPlacesFormat = "%.0f"
        itemsPerCollumnTextField.text = String(format: noDecimalPlacesFormat, stepper.value)
    }

    @IBAction
    func minimumInteritemSpacingStepperValueChanged(_ sender: Any) {
        guard let stepper = sender as? UIStepper else {
            return
        }
        let noDecimalPlacesFormat = "%.0f"
        minimumInteritemSpacingTextField.text = String(format: noDecimalPlacesFormat, stepper.value)
    }

    @IBAction
    func minimumLineSpacingStepperValueChanged(_ sender: Any) {
        guard let stepper = sender as? UIStepper else {
            return
        }
        let noDecimalPlacesFormat = "%.0f"
        minimumLineSpacingTextField.text = String(format: noDecimalPlacesFormat, stepper.value)
    }

    @IBAction
    func topSectionInsetStepperValueChanged(_ sender: Any) {
        guard let stepper = sender as? UIStepper else {
            return
        }
        let noDecimalPlacesFormat = "%.0f"
        topSectionInsetTextField.text = String(format: noDecimalPlacesFormat, stepper.value)
    }

    @IBAction
    func leftSectionInsetStepperValueChanged(_ sender: Any) {
        guard let stepper = sender as? UIStepper else {
            return
        }
        let noDecimalPlacesFormat = "%.0f"
        leftSectionInsetTextField.text = String(format: noDecimalPlacesFormat, stepper.value)
    }

    @IBAction
    func bottomSectionInsetValueChanged(_ sender: Any) {
        guard let stepper = sender as? UIStepper else {
            return
        }
        let noDecimalPlacesFormat = "%.0f"
        bottomSectionInsetTextField.text = String(format: noDecimalPlacesFormat, stepper.value)
    }

    @IBAction
    func rightSectionInserValueChanged(_ sender: Any) {
        guard let stepper = sender as? UIStepper else {
            return
        }
        let noDecimalPlacesFormat = "%.0f"
        rightSectionInsetTextField.text = String(format: noDecimalPlacesFormat, stepper.value)
    }
}
