//
//  DurationParserTests.swift
//  DNMModel
//
//  Created by James Bean on 1/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationParserTests: XCTestCase {

    func testParseEmptyStringNil() {
        let duration = DurationParser().parse("")
        XCTAssert(duration == nil)
    }
    
    func testParse1_8() {
        if let duration = DurationParser().parse("1,8") as? Duration {
            XCTAssert(duration.beats!.amount == 1)
            XCTAssert(duration.subdivision!.value == 8)
        } else {
            XCTFail()
        }
    }
    
    func testParse1_32() {
        if let duration = DurationParser().parse("1,32") as? Duration {
            XCTAssert(duration.beats!.amount == 1)
            XCTAssert(duration.subdivision!.value == 32)
        } else {
            XCTFail()
        }
    }
    
    func testParse319_24() {
        if let duration = DurationParser().parse("319,24") as? Duration {
            XCTAssert(duration.beats!.amount == 319)
            XCTAssert(duration.subdivision!.value == 24)
        } else {
            XCTFail()
        }
    }
    
    // TODO: add tests for gnarlier rhythmic and breaking situations
}
