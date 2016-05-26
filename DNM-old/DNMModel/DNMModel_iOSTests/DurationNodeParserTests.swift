//
//  DurationNodeParserTests.swift
//  DNMModel
//
//  Created by James Bean on 1/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationNodeParserTests: XCTestCase {

    /*
    func testParseEmptyStringNil() {
        let string = ""
        let durationNode = DurationNodeParser.parse(string)
        XCTAssert(durationNode == nil)
    }
    
    func testParseWithDuration() {
        let string = "3,16"
        let durationNode = DurationNodeParser.parse(string)
        if let durationNode = durationNode {
            XCTAssert(durationNode.duration == Duration(3,16))
        } else {
            XCTFail()
        }
    }
    
    func testParseWithDurationIntervalUntil() {
        let string = "3,16 -> 9,8"
        if let durationNode = DurationNodeParser.parse(string) {
            let expectedDurationInterval = DurationInterval(
                startDuration: Duration(3,16),
                stopDuration: Duration(9,8)
            )
            XCTAssert(durationNode.durationInterval == expectedDurationInterval)
        } else {
            XCTFail()
        }
    }
    
    func testParseWithDurationIntervalAt() {
        let string = "3,16 @ 9,8"
        if let durationNode = DurationNodeParser.parse(string) {
            let expectedDurationInterval = DurationInterval(
                duration: Duration(3,16),
                startDuration: Duration(9,8)
            )
            XCTAssert(durationNode.durationInterval == expectedDurationInterval)
        } else {
            XCTFail()
        }
    }
    */
}
