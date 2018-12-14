import UIKit

extension LayoutSettingsSceneViewController: KeyboardAvoidableProtocol {

    var layoutConstraintsToAdjust: [NSLayoutConstraint] {
        return [mainScrollViewBottomConstraint]
    }
}
