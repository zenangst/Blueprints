import Cocoa

extension NSView {

    static var defaultAnimationDuration: TimeInterval {
        return 0.2
    }

    static var defaultAnimationTimingFunction: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    }

    static func animate(duration: TimeInterval = defaultAnimationDuration,
                        timingFunction: CAMediaTimingFunction = defaultAnimationTimingFunction,
                        animations: () -> Void,
                        completion: (() -> Void)? = nil) {
        NSAnimationContext.runAnimationGroup({ context in
            context.allowsImplicitAnimation = true
            context.duration = duration
            context.timingFunction = timingFunction
            animations()
        }, completionHandler: completion)
    }

    static func animate(withDuration duration: TimeInterval = defaultAnimationDuration,
                        timingFunction: CAMediaTimingFunction = defaultAnimationTimingFunction,
                        animations: () -> Void) {
        animate(duration: duration, timingFunction: timingFunction, animations: animations, completion: nil)
    }
}
