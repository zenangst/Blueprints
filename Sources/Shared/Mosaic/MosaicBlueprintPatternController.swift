import Foundation

public class MosaicBlueprintPatternController {
  var patterns: [MosaicPattern]

  init(patterns: MosaicPattern ...) {
    self.patterns = patterns
  }

  init(patterns: [MosaicPattern]) {
    self.patterns = patterns
  }

  func values(at indexPath: IndexPath) -> MosaicPattern {
    let wrapped = patterns.count + (indexPath.item)
    let adjustedIndex = wrapped % patterns.count
    return patterns[adjustedIndex]
  }
}
