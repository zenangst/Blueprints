import UIKit

public extension CALayer {

  func addShadow(color: UIColor) {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.3
        self.shadowRadius = 5
        self.shadowColor = color.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }

  func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }

  func showShadow(duration: CFTimeInterval?) {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = self.shadowOpacity
        animation.toValue = 0.3
        animation.duration = (duration) ?? (0)
        self.add(animation, forKey: animation.keyPath)
        self.shadowOpacity = 0.3
    }

  func hideShadow(duration: CFTimeInterval?) {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = self.shadowOpacity
        animation.toValue = 0.0
        animation.duration = (duration) ?? (0)
        self.add(animation, forKey: animation.keyPath)
        self.shadowOpacity = 0.0
    }
}

extension CALayer {

    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            let contentLayerName = "contentLayer"
            masksToBounds = false
            sublayers?.filter { $0.frame.equalTo(self.bounds) }.forEach {
                $0.roundCorners(radius: self.cornerRadius)
            }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == contentLayerName {
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = contentLayerName
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
}
