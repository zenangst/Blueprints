//
//  LayoutExampleSceneWorker.swift
//  Example-OSX
//
//  Created by Chris on 16/01/2019.
//  Copyright © 2019 Christoffer Winterkvist. All rights reserved.
//

class LayoutExampleSceneWorker {

    func buildExampleData(forNumberOfSections sections: Int, numberOfRowsInSection rows: Int) -> [ExampleSection]? {
        let exampleData = ExampleDataMocks(numberOfSections: sections,
                                           numberOfRowsInSection: rows)
        return exampleData.sections
    }
}
