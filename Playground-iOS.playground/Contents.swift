import UIKit
import PlaygroundSupport
import Blueprints

class DataSource: NSObject, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath)
    cell.backgroundColor = .green
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
}

let dataSource = DataSource()
let blueprint = HorizontalBlueprintLayout(
  itemsPerRow: 3.5,
  itemsPerColumn: 2,
  itemSize: CGSize(width: 80, height: 80),
  sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
)
let frame = CGRect(origin: .zero, size: .init(width: 480, height: 640))
let collectionView = CollectionView(frame: frame, collectionViewLayout: blueprint)
collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
collectionView.dataSource = dataSource

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = collectionView

