import CoreGraphics

public class MosaicPattern {
  public enum Direction {
    case horizontal, vertical
  }
  public enum Alignment {
    case left, right
  }
  let amount: Int
  let alignment: MosaicPattern.Alignment
  let multiplier: CGFloat
  let direction: Direction

  public init(alignment: MosaicPattern.Alignment = .left, direction: Direction = .vertical, amount: Int, multiplier: CGFloat) {
    self.alignment = alignment
    self.amount = amount
    self.multiplier = multiplier
    self.direction = direction
  }
}
