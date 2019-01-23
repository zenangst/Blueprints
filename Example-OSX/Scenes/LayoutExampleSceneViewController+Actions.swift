import Cocoa

extension LayoutExampleSceneViewController {

    @IBAction func previousButtonDidClick(_ sender: Any) {
        activeLayout.switchToPreviousLayout()
        configureBluePrintLayout()
        configureSceneLayoutTitle()
    }

    @IBAction func nextButtonDidClick(_ sender: Any) {
        activeLayout.switchToNextLayout()
        configureBluePrintLayout()
        configureSceneLayoutTitle()
    }

    @IBAction func applyButtonDidClick(_ sender: Any) {
        let currentLayoutConfiguration = currentlayoutConfiguration()
        if currentConfiguration != currentLayoutConfiguration {
            currentConfiguration = currentLayoutConfiguration
            itemsPerRow = (currentConfiguration?.itemsPerRow) ?? (Constants.ExampleLayoutDefaults.itemsPerRow)
            itemsPerColumn = (currentConfiguration?.itemsPerCollumn) ?? (Constants.ExampleLayoutDefaults.itemsPerColumn)
            minimumLineSpacing = (currentConfiguration?.minimumLineSpacing) ?? (Constants.ExampleLayoutDefaults.minimumLineSpacing)
            sectionInsets = (currentConfiguration?.sectionInsets) ?? (Constants.ExampleLayoutDefaults.sectionInsets)
            configureBluePrintLayout()
        }
    }
}
