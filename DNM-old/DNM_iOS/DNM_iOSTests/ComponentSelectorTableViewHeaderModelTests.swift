//
//  ComponentSelectorTableViewHeaderModelTests.swift
//  DNM_iOS
//
//  Created by James Bean on 12/16/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import XCTest

class ComponentSelectorTableViewHeaderModelTests: XCTestCase {

    func testInit() {
        let headerModelThatBelongs = ComponentSelectorTableViewHeaderModel(
            performerID: "Violin I",
            states: [.Show],
            belongsToCurrentViewer: true
        )
        XCTAssert(headerModelThatBelongs.text == "Violin I")
        XCTAssert(headerModelThatBelongs.state == .On)
        
        let headerModelThatDoesNotBelong = ComponentSelectorTableViewHeaderModel(
            performerID: "Violoncello II",
            states: [.Show],
            belongsToCurrentViewer: false
        )
        XCTAssert(headerModelThatDoesNotBelong.state == .Off)
    }
}
