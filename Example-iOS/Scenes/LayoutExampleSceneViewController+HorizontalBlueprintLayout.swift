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

        // TODO: - Investigate the horizontal layout does not invalidate the the layout attributes
        /*let titleCollectionReusableViewSize = CGSize(width: view.bounds.width, height: 61)
        horizontalBlueprintLayout.headerReferenceSize = titleCollectionReusableViewSize
        horizontalBlueprintLayout.footerReferenceSize = titleCollectionReusableViewSize*/

        UIView.animate(withDuration: 0.5) { [weak self] in
            // TODO: - Remove, testing implementation
            self?.layoutExampleCollectionView.collectionViewLayout.invalidateLayout()
            self?.layoutExampleCollectionView.setCollectionViewLayout(horizontalBlueprintLayout, animated: true)
            // END

            //self?.layoutExampleCollectionView.collectionViewLayout = horizontalBlueprintLayout
            //self?.layoutExampleCollectionView.contentOffset.x = 0
            //self?.view.setNeedsLayout()
            //self?.view.layoutIfNeeded()
            //self?.navigationController?.navigationBar.sizeToFit()
        }
    }
}
