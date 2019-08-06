import UIKit

public class MockDataSource: NSObject, UICollectionViewDataSource {
  var numberOfItems: Int = 10
  var numberOfSections: Int = 1

  convenience init(numberOfItems: Int = 10, numberOfSections: Int = 1) {
    self.init()
    self.numberOfItems = numberOfItems
    self.numberOfSections = numberOfSections
  }

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return numberOfSections
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfItems
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    return cell
  }
}
