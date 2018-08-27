import Foundation

public class BinarySearch {
  public init() {}

  private func binarySearch(_ collection: [LayoutAttributes],
                               less: (LayoutAttributes) -> Bool,
                               match: (LayoutAttributes) -> Bool) -> Int? {
    var lowerBound = 0
    var upperBound = collection.count

    while lowerBound < upperBound {
      let midIndex = lowerBound + (upperBound - lowerBound) / 2
      let element = collection[midIndex]

      if match(element) {
        return midIndex
      } else if less(element) {
        lowerBound = midIndex + 1
      } else {
        upperBound = midIndex
      }
    }

    return nil
  }

  public func findElement(in collection: [LayoutAttributes],
                           less: (LayoutAttributes) -> Bool,
                           match: (LayoutAttributes) -> Bool) -> LayoutAttributes? {
    guard let firstMatchIndex = binarySearch(collection, less: less, match: match) else {
      return nil
    }
    return collection[firstMatchIndex]
  }

  public func findElements(in collection: [LayoutAttributes],
                              less: (LayoutAttributes) -> Bool,
                              match: (LayoutAttributes) -> Bool) -> [LayoutAttributes]? {
    guard let firstMatchIndex = binarySearch(collection, less: less, match: match) else {
      return nil
    }

    var results = [LayoutAttributes]()

    for element in collection[..<firstMatchIndex].reversed() {
      guard match(element) else { break }
      results.append(element)
    }

    for element in collection[firstMatchIndex...] {
      guard match(element) else { break }
      results.append(element)
    }

    return results
  }
}
