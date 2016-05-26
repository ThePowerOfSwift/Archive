//
//  DurationIntervalParserTests.swift
//  DNMModel
//
//  Created by James Bean on 1/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationIntervalParserTests: XCTestCase {

    func testParseEmptyStringNil() {
        let durationInterval = DurationIntervalParser().parse("") as? DurationInterval
        XCTAssert(durationInterval == nil)
    }
    
    func test1_8_until_2_8WithWhitespace() {
        let durationInterval = DurationIntervalParser().parse("1,8 -> 2,8")  as? DurationInterval
        XCTAssert(
            durationInterval == DurationInterval(
                startDuration: Duration(1,8),
                stopDuration: Duration(2,8)
            )
        )
    }
    
    func test1_8_until_2_8WithoutWhitespace() {
        let durationInterval = DurationIntervalParser().parse("1,8->2,8")  as? DurationInterval
        XCTAssert(
            durationInterval == DurationInterval(
                startDuration: Duration(1,8),
                stopDuration: Duration(2,8)
            )
        )
    }
    
    func testDurationZero_until_51_16() {
        let durationInterval = DurationIntervalParser().parse("0,8 -> 51,16")  as? DurationInterval
        XCTAssert(
            durationInterval == DurationInterval(
                startDuration: DurationZero,
                stopDuration: Duration(51,16)
            )
        )
    }
    
    func test4_8_at_5_8() {
        let durationInterval = DurationIntervalParser().parse("4,8 @ 5,8") as? DurationInterval
        XCTAssert(
            durationInterval == DurationInterval(
                duration: Duration(4,8),
                startDuration: Duration(5,8)
            )
        )
    }
}
