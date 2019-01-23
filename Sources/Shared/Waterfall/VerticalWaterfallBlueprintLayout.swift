import Foundation

@objc public class VerticalWaterfallBlueprintLayout: BlueprintLayout {

  @available(*, deprecated, message: "Layout has been deprecated, please use the VerticalBlueprintLayout instead. This will be removed in future updates.")
  override public init(itemsPerRow: CGFloat, itemSize: CGSize, estimatedItemSize: CGSize, minimumInteritemSpacing: CGFloat, minimumLineSpacing: CGFloat, sectionInset: EdgeInsets, animator: BlueprintLayoutAnimator) {
    fatalError("Layout has been deprecated")
  }

  @available(*, deprecated, message: "Layout has been deprecated, please use the VerticalBlueprintLayout instead. This will be removed in future updates.")
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
