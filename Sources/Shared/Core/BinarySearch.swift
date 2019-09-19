import Foundation

public class BinarySearch {
  public init() {}

  private func binarySearch(_ collection: [LayoutAttributes],
                            less: (LayoutAttributes) -> Bool,
                            match: (LayoutAttributes) -> Bool) -> Int? {
    guard var upperBound = collection.indices.last else { return nil }
    upperBound += 1
    var lowerBound = 0

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
                          upper: (LayoutAttributes) -> Bool,
                          lower: (LayoutAttributes) -> Bool,
                          less: (LayoutAttributes) -> Bool,
                          match: (LayoutAttributes) -> Bool) -> LayoutAttributes? {
    guard let firstMatchIndex = binarySearch(collection,
                                             less: less,
                                             match: match) else {
                                              return nil
    }
    return collection[firstMatchIndex]
  }

  public func findElements(in collection: [LayoutAttributes],
                           upper: (LayoutAttributes) -> Bool,
                           lower: (LayoutAttributes) -> Bool,
                           less: (LayoutAttributes) -> Bool,
                           match: (LayoutAttributes) -> Bool) -> [LayoutAttributes] {
    guard let firstMatchIndex = binarySearch(collection,
                                             less: less,
                                             match: match) else {
                                              return []
    }

    var results = [LayoutAttributes]()

    for element in collection[..<firstMatchIndex].reversed() {
      guard upper(element) else { break }
      results.append(element)
    }

    for element in collection[firstMatchIndex...] {
      guard lower(element) else { break }
      results.append(element)
    }

    return results
  }
}
