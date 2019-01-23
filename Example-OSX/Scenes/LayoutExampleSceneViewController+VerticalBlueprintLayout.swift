import Blueprints
import Cocoa

extension LayoutExampleSceneViewController {

    func configureVerticalLayout() {
        let verticalBlueprintLayout = VerticalBlueprintLayout(
            itemsPerRow: itemsPerRow,
            height: 95,
            minimumInteritemSpacing: minimumInteritemSpacing,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
            stickyHeaders: true,
            stickyFooters: true
        )

        let titleCollectionReusableViewSize = CGSize(width: view.bounds.width, height: 59)
        verticalBlueprintLayout.headerReferenceSize = titleCollectionReusableViewSize
        verticalBlueprintLayout.footerReferenceSize = titleCollectionReusableViewSize

        NSView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = verticalBlueprintLayout
            self?.scrollLayoutExampleCollectionViewToTopItem()
        }
    }
}
