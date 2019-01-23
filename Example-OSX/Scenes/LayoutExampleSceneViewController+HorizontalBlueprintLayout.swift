import Blueprints
import Cocoa

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

        NSView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = horizontalBlueprintLayout
            self?.scrollLayoutExampleCollectionViewToTopItem()
        }
    }
}
