//
//  DurationIntervalTests.swift
//  DNMModel
//
//  Created by James Bean on 11/27/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationIntervalTests: XCTestCase {

    func testInit() {
        var di = DurationIntervalZero
        XCTAssert(di.startDuration == DurationZero, "should be 0")
        XCTAssert(di.stopDuration == DurationZero, "should be 0")
        XCTAssert(di.duration == DurationZero, "should be 0")
        
        di = DurationInterval(oneDuration: Duration(1,8), andAnotherDuration: Duration(3,8))
        XCTAssert(di.startDuration == Duration(1,8), "should be 1,8")
        XCTAssert(di.stopDuration == Duration(3,8), "should be 3,8")
        XCTAssert(di.duration == Duration(2,8), "should be 2,8")
        
        di = DurationInterval(duration: Duration(1,8), startDuration: Duration(6,8))
        XCTAssert(di.duration == Duration(1,8), "should be 1,8")
        XCTAssert(di.startDuration == Duration(6,8), "should be 6,8")
        XCTAssert(di.stopDuration == Duration(7,8), "should be 7,8")
        
        di = DurationInterval(startDuration: Duration(4,8), stopDuration: Duration(7,8))
        XCTAssert(di.startDuration == Duration(4,8), "should be 4,8")
        XCTAssert(di.stopDuration == Duration(7,8), "should be 7,8")
        XCTAssert(di.duration == Duration(3,8), "should be 3,8")
    }
    
    func testInitWithString() {
        if let durationInterval = DurationInterval("4,8 -> 9,8") {
            let testInterval = DurationInterval(
                startDuration: Duration(4,8), stopDuration: Duration(9,8)
            )
            XCTAssert(durationInterval == testInterval)
        } else {
            XCTFail()
        }
    }
    
    func testMakeUnionWithDurationInterval() {
        let di0 = DurationInterval(startDuration: Duration(2,8), stopDuration: Duration(5,8))
        let di1 = DurationInterval(startDuration: Duration(3,8), stopDuration: Duration(6,8))
        let union = di0.makeUnionWithDurationInterval(di1)
        XCTAssert(union.startDuration == Duration(2,8), "should be 2,8")
        XCTAssert(union.stopDuration == Duration(6,8), "should be 6,8")
    }
    
    func testUnionWithDurationIntervals() {
        let di0 = DurationInterval(startDuration: Duration(2,8), stopDuration: Duration(5,8))
        let di1 = DurationInterval(startDuration: Duration(3,8), stopDuration: Duration(4,8))
        let di2 = DurationInterval(startDuration: Duration(4,8), stopDuration: Duration(9,8))
        let union = DurationInterval.unionWithDurationIntervals([di0, di1, di2])
        XCTAssert(union.startDuration == Duration(2,8), "start duration should be 2,8")
        XCTAssert(union.stopDuration == Duration(9,8), "stop duration should be 9,8")
    }
    
    func containsDuration() {
        let di = DurationInterval(startDuration: Duration(3,8), stopDuration: Duration(7,8))
        XCTAssert(!di.contains(Duration(2,8)), "should not contain duration before")
        XCTAssert(di.contains(Duration(3,8)), "should contain start duration")
        XCTAssert(di.contains(Duration(4,8)), "should contain duration in the middle")
        XCTAssert(!di.contains(Duration(7,8)), "should not contain stop duration")
        XCTAssert(!di.contains(Duration(9,8)), "should not contain duration after")
    }
    
    func testRelationshipToDurationInterval() {
        var di0 = DurationIntervalZero
        var di1 = DurationIntervalZero
        XCTAssert(di0.relationshipToDurationInterval(di1) == .Equal, "DIZero should be ==")
        
        
        // takes place before
        di1 = DurationInterval(startDuration: Duration(1,8), stopDuration: Duration(2,8))
        XCTAssert(di0.relationshipToDurationInterval(di1) == .TakesPlaceBefore,
            "should take place before"
        )
        
        // takes place after
        XCTAssert(di1.relationshipToDurationInterval(di0) == .TakesPlaceAfter,
            "should take place after"
        )
        
        // meets
        di0 = DurationInterval(startDuration: Duration(3,8), stopDuration: Duration(6,8))
        di1 = DurationInterval(startDuration: Duration(6,8), stopDuration: Duration(9,8))
        XCTAssert(di0.relationshipToDurationInterval(di1) == .Meets, "should be meets")
        XCTAssert(di1.relationshipToDurationInterval(di0) == .Meets, "should be meets?")
        
        // overlaps
        di1 = DurationInterval(startDuration: Duration(4,8), stopDuration: Duration(8,8))
        XCTAssert(di0.relationshipToDurationInterval(di1) == .Overlaps, "should be overlaps")
        XCTAssert(di1.relationshipToDurationInterval(di0) == .Overlaps, "should be overlaps")
        
        // during
        di0 = DurationInterval(startDuration: Duration(5,8), stopDuration: Duration(6,8))
        XCTAssert(di0.relationshipToDurationInterval(di1) == .During, "should be during")
        
        // start
        di0 = DurationInterval(startDuration: Duration(4,8), stopDuration: Duration(7,8))
        XCTAssert(di0.relationshipToDurationInterval(di1) == .Starts, "should be starts")
    
        // finishes
        di0 = DurationInterval(startDuration: Duration(6,8), stopDuration: Duration(8,8))
        XCTAssert(di0.relationshipToDurationInterval(di1) == .Finishes, "should be finishes")
    }
    
    func testTrimStartDuration() {
        var di = DurationInterval(startDuration: DurationZero, stopDuration: Duration(9,16))
        di.trimStartDurationTo(Duration(1,16))
        XCTAssert(di.startDuration == Duration(1,16))
        XCTAssert(di.duration == Duration(8,16))
    }
    
    func testTrimStopDuration() {
        var di = DurationInterval(startDuration: DurationZero, stopDuration: Duration(9,16))
        di.trimStopDurationTo(Duration(7,16))
        XCTAssert(di.stopDuration == Duration(7,16))
        XCTAssert(di.duration == Duration(7,16))
    }
    
    func testContainsDuration() {
        let di = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(9,16))
        let d0 = DurationZero
        XCTAssert(!di.contains(d0))
        let d1 = Duration(1,8)
        XCTAssert(!di.contains(d1))
        let d2 = Duration(2,8)
        XCTAssert(di.contains(d2))
        let d3 = Duration(9,16)
        XCTAssert(!di.contains(d3))
        let d4 = Duration(24,8)
        XCTAssert(!di.contains(d4))
    }
    
    func containsDurationInterval() {
        // compare other duration intervals to this one
        let di0 = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(11,16))
        
        let di1 = DurationInterval(startDuration: DurationZero, stopDuration: Duration(1,16))
        XCTAssert(!di0.contains(di1))
        XCTAssert(!di1.contains(di0))
        
        let di2 = DurationInterval(startDuration: Duration(2,16), stopDuration: Duration(6,16))
        XCTAssert(!di0.contains(di2))
        XCTAssert(!di2.contains(di0))
    }
    
    func bisectAtDurationNilUnder() {
        let di = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(9,16))
        let result = di.bisectAtDuration(Duration(1,16))
        XCTAssert(result == nil)
    }
    
    func bisectAtDurationNilOver() {
        let di = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(9,16))
        let result = di.bisectAtDuration(Duration(21,16))
        XCTAssert(result == nil)
    }
    
    func bisectAtDuration() {
        let di = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(9,16))
        let result = di.bisectAtDuration(Duration(4,16))
        XCTAssert(result != nil)
        XCTAssert(
            result!.0 == DurationInterval(
                startDuration: Duration(3,16), stopDuration: Duration(4,16)
            )
        )
        XCTAssert(
            result!.1 == DurationInterval(
                startDuration: Duration(4,16), stopDuration: Duration(9,16)
            )
        )
    }

    // Check this
    func testIntersectsWithDurationInterval() {
        // compare other duration intervals to this one
        let di0 = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(11,16))
        
        let di1 = DurationInterval(startDuration: DurationZero, stopDuration: Duration(3,16))
        XCTAssert(!di0.intersectsWith(di1))
        XCTAssert(!di1.intersectsWith(di0))
        
        let di2 = DurationInterval(startDuration: DurationZero, stopDuration: Duration(2,8))
        XCTAssert(di0.intersectsWith(di2))
        XCTAssert(di2.intersectsWith(di0))
        
        let di3 = DurationInterval(startDuration: Duration(4,16), stopDuration: Duration(9,16))
        XCTAssert(di0.intersectsWith(di3))
        
        // check this condition -- something weird with relationship to DurationInterval
        //XCTAssert(di3.intersectsWith(di0))
    }
    
    func testIntersectsWithDurationNode() {
        let durationNode = DurationNodeIntervalEnforcing(
            duration: Duration(4,8), offsetDuration: DurationZero, sequence: [1,1,1,1]
        )
        let di0 = DurationInterval(startDuration: DurationZero, stopDuration: Duration(4,8))
        XCTAssert(di0.intersectsWith(durationNode))
        
        let di1 = DurationInterval(startDuration: Duration(4,8), stopDuration: Duration(5,8))
        XCTAssert(!di1.intersectsWith(durationNode))
    }
    
    func testEquality() {
        let di0 = DurationInterval(startDuration: Duration(1,8), stopDuration: Duration(2,8))
        var di1 = DurationInterval(startDuration: Duration(1,8), stopDuration: Duration(2,8))
        XCTAssert(di0 == di1, "should be equal")
        
        di1 = DurationInterval(startDuration: Duration(3,8), stopDuration: Duration(5,8))
        XCTAssert(di0 != di1, "should not be equal")
    }
}