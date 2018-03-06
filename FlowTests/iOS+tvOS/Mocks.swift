import UIKit

public class MockDataSource: NSObject, UICollectionViewDataSource {
  var numberOfItems: Int = 10

  convenience init(numberOfItems: Int = 10) {
    self.init()
    self.numberOfItems = numberOfItems
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfItems
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    return cell
  }
}
