//
//  PerformerTests.swift
//  DNMModel
//
//  Created by James Bean on 12/16/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import XCTest
import DNMModel

class PerformerTests: XCTestCase {

    func testInit() {
        let performer0 = Performer(identifier: "VNI")
        XCTAssert(performer0.identifier == "VNI")
        XCTAssert(performer0.abbreviatedName == "VNI")
        XCTAssert(performer0.fullName == "VNI")
        
        let performer1 = Performer(
            identifier: "VNI",
            fullName: "Violin I",
            abbreviatedName: "VN I",
            instrumentTypes: [InstrumentType.Violin]
        )
        XCTAssert(performer1.identifier == "VNI")
        XCTAssert(performer1.fullName == "Violin I")
        XCTAssert(performer1.abbreviatedName == "VN I")
        XCTAssert(performer1.instrumentTypes == [InstrumentType.Violin])
    }
}
