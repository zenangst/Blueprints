import Blueprints
import UIKit

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
        
      let titleCollectionReusableViewSize = CGSize(width: view.bounds.width, height: 61)
      mosaicBlueprintLayout.headerReferenceSize = titleCollectionReusableViewSize
      mosaicBlueprintLayout.footerReferenceSize = titleCollectionReusableViewSize
      
      UIView.animate(withDuration: 0.5) { [weak self] in
        self?.layoutExampleCollectionView.collectionViewLayout = mosaicBlueprintLayout
        self?.view.setNeedsLayout()
      }
  }
}
