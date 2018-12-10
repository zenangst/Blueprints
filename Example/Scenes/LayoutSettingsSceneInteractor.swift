//
//  LayoutSettingsSceneInteractor.swift
//  Blueprints
//
//  Created by Chris on 10/12/2018.
//  Copyright (c) 2018 Christoffer Winterkvist. All rights reserved.
//

import UIKit

protocol LayoutSettingsSceneBusinessLogic {

    func getLayoutConfiguration(request: LayoutSettingsScene.GetLayoutConfiguration.Request)
}

protocol LayoutSettingsSceneDataStore {

    var itemsPerRow: CGFloat? { get set } // MARK: - Excludes Mosaic
    var itemsPerCollumn: Int? { get set } // MARK: - Horizontal Only
    var minimumInteritemSpacing: CGFloat? { get set }
    var minimumLineSpacing: CGFloat? { get set }
    var sectionInsets: UIEdgeInsets? { get set }
}

class LayoutSettingsSceneInteractor: LayoutSettingsSceneBusinessLogic, LayoutSettingsSceneDataStore {
    var presenter: LayoutSettingsScenePresentationLogic?
    var worker: LayoutSettingsSceneWorker?
    var itemsPerRow: CGFloat?
    var itemsPerCollumn: Int?
    var minimumInteritemSpacing: CGFloat?
    var minimumLineSpacing: CGFloat?
    var sectionInsets: UIEdgeInsets?
}

extension LayoutSettingsSceneInteractor {

    func getLayoutConfiguration(request: LayoutSettingsScene.GetLayoutConfiguration.Request) {
        let response = LayoutSettingsScene
            .GetLayoutConfiguration
            .Response(itemsPerRow: self.itemsPerRow,
                      itemsPerCollumn: self.itemsPerCollumn,
                      minimumInteritemSpacing: self.minimumInteritemSpacing,
                      minimumLineSpacing: self.minimumLineSpacing,
                      sectionInsets: self.sectionInsets)
        presenter?.presentLayoutConfiguration(response: response)
    }
}
