//
//  ComponentRepresentationTypeTests.swift
//  DNMModel
//
//  Created by James Bean on 1/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class ComponentRepresentationTypeTests: XCTestCase {

    func testEquality() {
        let reprType: ComponentRepresentationType = .GraphDecorating
        XCTAssert(reprType == .GraphDecorating)
    }
    
    func testCombinations() {
        let reprType: ComponentRepresentationType = [.GraphBearing, .GraphDecorating]
        XCTAssert(reprType == [.GraphBearing, .GraphDecorating])
        XCTAssert(reprType.contains(.GraphBearing))
    }
}
