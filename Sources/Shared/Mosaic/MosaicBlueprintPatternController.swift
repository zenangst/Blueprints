import Foundation

@objc public class MosaicBlueprintPatternController: NSObject {
  var patterns: [MosaicPattern]

  public init(patterns: MosaicPattern ...) {
    self.patterns = patterns
  }

  public init(patterns: [MosaicPattern]) {
    self.patterns = patterns
  }

  func values(at indexPath: IndexPath) -> MosaicPattern {
    let wrapped = patterns.count + (indexPath.item)
    let adjustedIndex = wrapped % patterns.count
    return patterns[adjustedIndex]
  }
}
