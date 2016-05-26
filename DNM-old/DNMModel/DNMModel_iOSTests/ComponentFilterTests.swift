//
//  ComponentFilterTests.swift
//  DNMModel
//
//  Created by James Bean on 1/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class ComponentFilterTests: XCTestCase {
    
    func testInit() {
        let durationInterval = DurationInterval(
            startDuration: Duration(3,16),
            stopDuration: Duration(11,16)
        )
        let componentFilter = ComponentFilter(durationInterval: durationInterval)
        XCTAssertEqual(durationInterval, componentFilter.durationInterval,
            "interval not set correctly"
        )
    }
    
    func testComponentTypes() {
        let di = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(11,16))
        var componentFilter = ComponentFilter(durationInterval: di)
        
        componentFilter.componentTypeModel = ["VN": ["dynamics": .Show]]
        XCTAssertEqual(
            componentFilter.componentTypeModel["VN"]!["dynamics"]!,
            ComponentTypeState.Show,
            "should be shown"
        )
    }
    
    func testBisect() {
        let di = DurationInterval(startDuration: DurationZero, stopDuration: Duration(9,16))
        let componentFilter = ComponentFilter(durationInterval: di)
        if let (first, second) = componentFilter.bisectAtDuration(Duration(4,16)) {
            let expectedFirstDurationInterval = DurationInterval(
                startDuration: DurationZero, stopDuration: Duration(4,16)
            )
            let expectedSecondDurationInterval = DurationInterval(startDuration: Duration(4,16), stopDuration: Duration(9,16)
            )
            XCTAssertEqual(first.durationInterval, expectedFirstDurationInterval, "should be ==")
            XCTAssertEqual(second.durationInterval, expectedSecondDurationInterval, "expected ==")
            
        } else {
            XCTFail("couldn't create bisection")
        }
    }
    
    func testBisectOutOfRange() {
        let di = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(9,16))
        let componentFilter = ComponentFilter(durationInterval: di)
        let nilBisectionBefore = componentFilter.bisectAtDuration(Duration(11,16))
        let nilBisectionAfter = componentFilter.bisectAtDuration(Duration(1,16))
        XCTAssert(nilBisectionBefore == nil, "should be nil")
        XCTAssert(nilBisectionAfter == nil, "should be nil")
    }
}
