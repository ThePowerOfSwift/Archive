//
//  MIDITests.swift
//  DNMModel_iOSTests
//
//  Created by James Bean on 3/17/15.
//  Copyright (c) 2015 James Bean. All rights reserved.
//

import UIKit
import XCTest
@testable import DNMModel

class MIDITests: XCTestCase {
    
    func testInitMiddleC() {
        let m = MIDI(60.0)
        XCTAssert(m.value == 60.0, "value not set correclty")
    }
    
    // TODO: more exhaustive tests
    func testInitWithResolution() {
        let m = MIDI(value: 60.3, resolution: 1)
        XCTAssert(m.value == 60.0, "value not set correclty")
    }
    
    func testQuantizeToResolutionEighthTone() {
        var m = MIDI(60.23)
        m.quantizeToResolution(0.25)
        XCTAssert(m.value == 60.25, "value not quantized to resolution correctly")
    }
    
    func testQuantizeToResolutionQuarterTone() {
        var n = MIDI(60.73)
        n.quantizeToResolution(0.5)
        XCTAssert(n.value == 60.5, "value not quantized to resolution correctly")
    }
    
    func testQuantizeToResolutionHalfTone() {
        var n = MIDI(60.73)
        n.quantizeToResolution(1)
        XCTAssert(n.value == 61, "value not quantized to resolution correctly")
    }
    
    // TODO: break out into individual tests
    func testComparison() {
        let m0 = MIDI(60)
        let m1 = MIDI(65)
        let m2 = MIDI(65)
        XCTAssert(m0 < m1, "should be <")
        XCTAssert(m0 <= m1, "should be <=")
        XCTAssert(m0 != m1, "should be !=")
        XCTAssert(m1 > m0, "should be >")
        XCTAssert(m1 >= m0, "should be >=")
        XCTAssert(m1 == m2, "should be ==")
        XCTAssert(m1 >= m2, "should be >=")
        XCTAssert(m1 <= m2, "should be <=")
    }
    
    func testAdd() {
        let m0 = MIDI(60)
        let m1 = MIDI(9.5)
        XCTAssert(m0 + m1 == MIDI(69.5), "should be 69.5")
    }
    
    func testSubtract() {
        let m0 = MIDI(60)
        let m1 = MIDI(10)
        XCTAssert(m0 - m1 == MIDI(50))
    }
    
    func testModulo() {
        let m2 = MIDI(62.25)
        XCTAssert(m2 % Float(12.0) == MIDI(2.25), "should be 2.25")
    }
}