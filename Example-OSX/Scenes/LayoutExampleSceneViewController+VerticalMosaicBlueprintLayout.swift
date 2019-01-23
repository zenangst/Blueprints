import Blueprints
import Cocoa

extension LayoutExampleSceneViewController {

    func configureMosaicLayout() {
        let mosaicBlueprintLayout = VerticalMosaicBlueprintLayout(
            patternHeight: 400,
            minimumInteritemSpacing: minimumInteritemSpacing,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
            patterns: [
                MosaicPattern(alignment: .left,
                              direction: .vertical,
                              amount: 2,
                              multiplier: 0.6),
                MosaicPattern(alignment: .left,
                              direction: .horizontal,
                              amount: 2,
                              multiplier: 0.33),
                MosaicPattern(alignment: .left,
                              direction: .vertical,
                              amount: 1,
                              multiplier: 0.5),
                MosaicPattern(alignment: .left,
                              direction: .vertical,
                              amount: 1,
                              multiplier: 0.5)
            ])

        NSView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutExampleCollectionView.collectionViewLayout = mosaicBlueprintLayout
            self?.scrollLayoutExampleCollectionViewToTopItem()
        }
    }
}
