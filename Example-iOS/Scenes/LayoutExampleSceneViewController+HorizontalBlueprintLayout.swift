import Blueprints
import UIKit

extension LayoutExampleSceneViewController {

    func configureHorizontalLayout() {
        let horizontalBlueprintLayout = HorizontalBlueprintLayout(
            itemsPerRow: itemsPerRow,
            itemsPerColumn: itemsPerColumn,
            itemSize: CGSize(width: 200,
                             height: 95),
            minimumInteritemSpacing: minimumInteritemSpacing,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
            stickyHeaders: true,
            stickyFooters: true
        )

        // TODO: - Uncomment once https://github.com/zenangst/Blueprints/issues/49 has been investigated and resolved.
        /*let titleCollectionReusableViewSize = CGSize(width: view.bounds.width, height: 61)
        horizontalBlueprintLayout.headerReferenceSize = titleCollectionReusableViewSize
        horizontalBlueprintLayout.footerReferenceSize = titleCollectionReusableViewSize*/

        UIView.animate(withDuration: 0.5) { [weak self] in
            // TODO: - Remove once https://github.com/zenangst/Blueprints/issues/49 has been investigated and resolved.
            self?.layoutExampleCollectionView.collectionViewLayout.invalidateLayout()
            self?.layoutExampleCollectionView.setCollectionViewLayout(horizontalBlueprintLayout, animated: true)
            self?.layoutExampleCollectionView.contentOffset.x = 0
            // TODO: - Uncomment once https://github.com/zenangst/Blueprints/issues/49 has been investigated and resolved.
            /*self?.layoutExampleCollectionView.collectionViewLayout = horizontalBlueprintLayout
            self?.layoutExampleCollectionView.contentOffset.x = 0
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()*/
            self?.navigationController?.navigationBar.sizeToFit()
        }
    }
}
