//
//  DurationNodeLeafModelTests.swift
//  DNMModel
//
//  Created by James Bean on 1/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationNodeLeafModelTests: XCTestCase {

    func testInit() {
        var model = DurationNodeLeafModel()
        
        // create duration node
        let dn = DurationNode.with(Duration(3,16))
        dn.components = [
            ComponentPitch(performerID: "VN", instrumentID: "vn", values: [60]),
            ComponentArticulation(performerID: "VN", instrumentID: "vn", values: ["."]),
            ComponentDynamicMarking(performerID: "VN", instrumentID: "vn", value: "ppp"),
            ComponentPitch(performerID: "VN", instrumentID: "vx", values: [63]),
            ComponentArticulation(performerID: "VN", instrumentID: "vx", values: ["-"]),
            ComponentPitch(performerID: "VC", instrumentID: "vc", values: [62]),
            ComponentDynamicMarking(performerID: "VC", instrumentID: "vc", value: "fff")
        ]
        model.addLeaf(dn)
        print(model)
    }
}
