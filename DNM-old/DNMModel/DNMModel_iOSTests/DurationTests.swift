//
//  DurationTests.swift
//  DurationTests
//
//  Created by James Bean on 3/13/15.
//  Copyright (c) 2015 James Bean. All rights reserved.
//

import UIKit
import XCTest
@testable import DNMModel

class DurationTests: XCTestCase {
    
    func testInitBeatsInt() {
        let duration = Duration(beats: 4)
        if let beats = duration.beats, subdivision = duration.subdivision {
            XCTAssert(beats.amount == 4)
            XCTAssert(subdivision.value == 1)
        } else {
            XCTFail()
        }
    }
    
    func testInitBeatsAndSubdivision() {
        let duration = Duration(beats: Beats(amount: 3), subdivision: Subdivision(value: 16))
        if let beats = duration.beats, subdivision = duration.subdivision {
            XCTAssert(beats.amount == 3)
            XCTAssert(subdivision.value == 16)
        } else {
            XCTFail()
        }
    }
    
    func testDurationInitWithString() {
        if let duration = Duration(string: "1,8") {
            XCTAssert(duration == Duration(1,8))
        } else {
            XCTFail()
        }
    }
    
    func testDefaultScale() {
        let duration = Duration(4,8)
        XCTAssert(duration.scale == 1.0)
    }
    
    func testInheritedScale() {
        var duration = Duration(1,8)
        duration.setScale(0.75)
        XCTAssert(duration.scale == 0.75)
    }
    
    func testInitWithFloatValue_1_8() {
        let duration = Duration(floatValue: 1)
        if let beats = duration.beats, subdivision = duration.subdivision {
            XCTAssert(beats.amount == 1)
            XCTAssert(subdivision.value == 8)
        } else {
            XCTFail()
        }
    }
    
    func testInitWithFloatValue_3_16() {
        let duration = Duration(floatValue: 1.5)
        if let beats = duration.beats, subdivision = duration.subdivision {
            XCTAssert(beats.amount == 3)
            XCTAssert(subdivision.value == 16)
        } else {
            XCTFail()
        }
    }
    
    func testInitFloatValue_7_64() {
        let duration = Duration(floatValue: 0.875)
        if let beats = duration.beats, subdivision = duration.subdivision {
            XCTAssert(beats.amount == 7)
            XCTAssert(subdivision.value == 64)
        } else {
            XCTFail()
        }
    }
    
    func testInitFloatValue_0() {
        XCTAssertEqual(Duration(floatValue: 0.0), DurationZero)
    }
    
    func testDurationCompare() {
        var d1 = Duration(7, 16)
        var d2 = Duration(3,8)
        XCTAssert(d1 != d2, "non equiv durs are equiv")
        XCTAssert(d1 >= d2, "d1 not less than or equal to d2")
        XCTAssert(d2 <= d1, "d2 not greater than or equal to d1")
        d2.setSubdivisionValue(32)
        d2.setBeats(14)
        XCTAssert(d1 == d2, "equiv durs not equiv")
        d1.setBeats(30)
        XCTAssert(d1 > d2, "d1 not greater than d2")
        XCTAssert(d2 < d1, "d2 not less than d1")
    }
    
    func testDurationAdd() {
        var d1 = Duration(7,16)
        let d2 = Duration(3,8)
        XCTAssert(d1 + d2 == Duration(13,16), "durs not added correctly")
        let d3 = Duration(2,4)
        let d4 = Duration(13,32)
        XCTAssert(d3 + d4 == Duration(29,32), "durs not added correctly")
        let d5 = d3 - d4
        XCTAssert(d5 == Duration(3,32), "durs not subtracted correctly")
        var d6 = Duration(17,16)
        let d7 = Duration(3,8)
        XCTAssert(d6 - d7 == Duration(11,16), "durs not subtracted correctly")
        d6 += d7
        XCTAssert(d6 == Duration(23,16), "durs not added correctly")
        d1 -= d2
        XCTAssert(d1 == Duration(1,16), "durs not subdtracted correctly")
    }
    
    func testDurationMultiplyDivide() {
        let d1 = Duration(7,16)
        var d2 = d1 * 2
        XCTAssert(d2 == Duration(14,16), "dur not multplied correctly")
        d2 *= 2
        XCTAssert(d2 == Duration(28,16), "dur not multiplied correctly")
        let d3 = Duration(6,8)
        let d4 = d3 / 2
        XCTAssert(d4 == Duration(3,8), "dur not divided correctly")
        let d5 = Duration(13,16)
        let d6 = d5 / 2
        XCTAssert(d6 == Duration(13,32), "dur not divided correctly")
    }
    
    func testDurationRespellAccordingToBeats() {
        var d1 = Duration(7,16)
        d1.respellAccordingToBeats(Beats(amount: 14))
        XCTAssert(d1 == Duration(7,16), "not respelled correctly")
        XCTAssert(d1.beats!.amount == 14, "beats not respelled correctly")
        XCTAssert(d1.subdivision!.value == 32, "subdivision not respelled correctly")
        d1.respellAccordingToBeats(28)
        XCTAssert(d1 == Duration(28,64), "not respelled correctly")
        d1.respellAccordingToBeats(7)
        XCTAssert(d1 == Duration(7,16), "not respelled correctly")
    }
    
    func testDurationRespellAccordingToSubdivision() {
        var d1 = Duration(7,16)
        d1.respellAccordingToSubdivision(Subdivision(value: 32))
        XCTAssert(d1 == Duration(7,16), "not respelled correctly")
        XCTAssert(d1.beats!.amount == 14, "beats not respelled correctly")
        XCTAssert(d1.subdivision!.value == 32, "subdivision not respelled correctly")
        d1.respellAccordingToSubdivisionValue(64)
        XCTAssert(d1 == Duration(28,64), "not respelled correctly")
        d1.respellAccordingToSubdivisionValue(16)
        XCTAssert(d1 == Duration(7,16), "not respelled correctly")
    }
}