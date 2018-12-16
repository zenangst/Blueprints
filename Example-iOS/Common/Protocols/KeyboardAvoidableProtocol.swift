import Foundation
import UIKit

protocol KeyboardAvoidableProtocol: class {

    typealias KeyboardHeightDuration = (height: CGFloat, duration: Double)
    typealias KeyboardHeightDurationBlock = (KeyboardHeightDuration) -> Void
    typealias KeyboardTranstionCompletionBlock = (CGFloat?) -> Void

    func addKeyboardObservers(block: KeyboardHeightDurationBlock?, onKeyboardTransitionCompletion completion: KeyboardTranstionCompletionBlock?)
    func removeKeyboardObservers()
    var layoutConstraintsToAdjust: [NSLayoutConstraint] { get }
}

private var keyboardShowObserverObjectKey: UInt8 = 1
private var keyboardHideObserverObjectKey: UInt8 = 2

extension KeyboardAvoidableProtocol where Self: UIViewController {

    var keyboardShowObserverObject: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(
                self,
                &keyboardShowObserverObjectKey) as? NSObjectProtocol
        }
        set {
            objc_setAssociatedObject(
                self,
                &keyboardShowObserverObjectKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var keyboardHideObserverObject: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(
                self,
                &keyboardHideObserverObjectKey) as? NSObjectProtocol
        }
        set {
            objc_setAssociatedObject(
                self,
                &keyboardHideObserverObjectKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func addKeyboardObservers(block: KeyboardHeightDurationBlock? = nil, onKeyboardTransitionCompletion completion: KeyboardTranstionCompletionBlock? = nil) {
        let notificationCenter = NotificationCenter.default

        self.removeKeyboardObservers()

        keyboardShowObserverObject = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil) { [weak self] notification in
                guard let heightDuration = self?.getKeyboardHeightDurationFrom(notification: notification) else {
                    return
                }
                if let block = block {
                    block(heightDuration)
                    return
                }
                self?.layoutConstraintsToAdjust.forEach {
                    $0.constant = heightDuration.height
                }
                UIView.animate(withDuration: heightDuration.duration, animations: {
                    self?.view.layoutIfNeeded()
                }, completion: { _ in
                    completion?(heightDuration.height)
                })
        }

        keyboardHideObserverObject = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil) { [weak self] _ in
                if let customBlock = block {
                    customBlock((0, 0.3))
                    return
                }
                self?.layoutConstraintsToAdjust.forEach {
                    $0.constant = 0
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self?.view.layoutIfNeeded()
                }, completion: { _ in
                    completion?(nil)
                })
        }
    }

    func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default

        if let keyboardShowObserverObject = keyboardShowObserverObject {
            notificationCenter.removeObserver(keyboardShowObserverObject)
        }
        if let keyboardHideObserverObject = keyboardHideObserverObject {
            notificationCenter.removeObserver(keyboardHideObserverObject)
        }
        keyboardShowObserverObject = nil
        keyboardHideObserverObject = nil
    }
}

private extension KeyboardAvoidableProtocol {

    private func getKeyboardHeightDurationFrom(notification: Notification) -> KeyboardHeightDuration? {
        guard let userInfo = notification.userInfo,
            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                return nil
        }
        return (rect.height, duration)
    }
}
