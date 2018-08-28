import CoreGraphics
import Foundation

@objc public class MosaicPattern: NSObject {
  @objc public enum Direction: Int {
    case horizontal, vertical
  }
  @objc public enum Alignment: Int {
    case left, right
  }
  let amount: Int
  let alignment: MosaicPattern.Alignment
  let multiplier: CGFloat
  let direction: Direction

  @objc public init(alignment: MosaicPattern.Alignment = .left,
                    direction: Direction = .vertical,
                    amount: Int,
                    multiplier: CGFloat) {
    self.alignment = alignment
    self.amount = amount
    self.multiplier = multiplier
    self.direction = direction
    super.init()
  }
}
