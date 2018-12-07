//
//  LayoutExampleSceneWorker.swift
//  Blueprints
//
//  Created by Chris on 06/12/2018.
//  Copyright (c) 2018 Christoffer Winterkvist. All rights reserved.
//

class LayoutExampleSceneWorker {

    func buildExampleData(forNumberOfSections sections: Int, numberOfRowsInSection rows: Int) -> [ExampleSection]? {
        let exampleData = ExampleDataMocks(numberOfSections: sections,
                                           numberOfRowsInSection: rows)
        return exampleData.sections
    }
}
