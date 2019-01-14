import Blueprints
import UIKit

extension LayoutExampleSceneViewController {

    func configureHorizontalLayout() {
        let horizontalBlueprintLayout = HorizontalBlueprintLayout(
          itemsPerRow: itemsPerRow,
          itemsPerColumn: itemsPerColumn,
          height: 95,
          minimumInteritemSpacing: minimumInteritemSpacing,
          minimumLineSpacing: minimumLineSpacing,
          sectionInset: sectionInsets,
          stickyHeaders: true,
          stickyFooters: true
        )

        let titleCollectionReusableViewSize = CGSize(width: view.bounds.width, height: 61)
        horizontalBlueprintLayout.headerReferenceSize = titleCollectionReusableViewSize
        horizontalBlueprintLayout.footerReferenceSize = titleCollectionReusableViewSize

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = horizontalBlueprintLayout
            self?.layoutExampleCollectionView.contentOffset.x = 0
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
            self?.navigationController?.navigationBar.sizeToFit()
        }
    }
}
