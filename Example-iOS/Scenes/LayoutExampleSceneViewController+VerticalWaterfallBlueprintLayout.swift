import Blueprints
import UIKit

extension LayoutExampleSceneViewController {

    func configureWaterFallLayout() {
        let waterfallBlueprintLayout = VerticalWaterfallBlueprintLayout(
            itemsPerRow: itemsPerRow,
            itemSize: CGSize.init(width: 50,
                                  height: 95),
            minimumInteritemSpacing: minimumInteritemSpacing,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets
        )

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = waterfallBlueprintLayout
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
    }
}
