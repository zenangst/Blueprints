//
//  LayoutSettingsScenePresenter.swift
//  Blueprints
//
//  Created by Chris on 10/12/2018.
//  Copyright (c) 2018 Christoffer Winterkvist. All rights reserved.
//

protocol LayoutSettingsScenePresentationLogic {

    func presentLayoutConfiguration(response: LayoutSettingsScene.GetLayoutConfiguration.Response)
}

class LayoutSettingsScenePresenter: LayoutSettingsScenePresentationLogic {
    
    weak var viewController: LayoutSettingsSceneDisplayLogic?
}

extension LayoutSettingsScenePresenter {

    func presentLayoutConfiguration(response: LayoutSettingsScene.GetLayoutConfiguration.Response) {
        let noDecimalPlacesFormat = "%.0f"
        let oneDecimalPlacesFormat = "%.1f"

        let itemsPerRow = String(format: oneDecimalPlacesFormat, (response.itemsPerRow) ?? (0))
        let itemsPerCollumn = String((response.itemsPerCollumn) ?? (0))
        let minimumInteritemSpacing = String(format: noDecimalPlacesFormat, (response.minimumInteritemSpacing) ?? (0))
        let minimumLineSpacing = String(format: noDecimalPlacesFormat, (response.minimumLineSpacing) ?? (0))
        let topSectionInset = String(format: noDecimalPlacesFormat, (response.sectionInsets?.top) ?? (0))
        let leftSectionInset = String(format: noDecimalPlacesFormat, (response.sectionInsets?.left) ?? (0))
        let bottomSectionInset = String(format: noDecimalPlacesFormat, (response.sectionInsets?.bottom) ?? (0))
        let rightSectionInset = String(format: noDecimalPlacesFormat, (response.sectionInsets?.right) ?? (0))

        let viewModel = LayoutSettingsScene.GetLayoutConfiguration.ViewModel(itemsPerRow: itemsPerRow,
                                                                             itemsPerCollumn: itemsPerCollumn,
                                                                             minimumInteritemSpacing: minimumInteritemSpacing,
                                                                             minimumLineSpacing: minimumLineSpacing,
                                                                             topSectionInset: topSectionInset,
                                                                             leftSectionInset: leftSectionInset,
                                                                             bottomSectionInset: bottomSectionInset,
                                                                             rightSectionInset: rightSectionInset)

        viewController?.presentLayoutConfiguration(viewModel: viewModel)
    }
}
