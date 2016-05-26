//
//  DurationNodeIntervalEnforcingTests.swift
//  DNMModel
//
//  Created by James Bean on 1/18/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationNodeIntervalEnforcingTests: XCTestCase {

    func testInitFromDurationNodeWithDurationNode() {
        let durationNode = DurationNode.with(1,8)
        XCTAssert(durationNode.duration == Duration(1,8))
    }
    
    /*
    func testAddChildWithBeatsMultiple() {
        let rootDurationNode = DurationNode.with(1,8)
        rootDurationNode.addChildWith(1)
        rootDurationNode.addChildWith(1)
        rootDurationNode.addChildWith(1)
        XCTAssert(rootDurationNode.children.count == 3)
    }
    */
    
    func testInitWithSequenceSingle() {
        let rootDurationNode = DurationNode.with(Duration(1,8), sequence: [1])
        XCTAssert(rootDurationNode.children.count == 1)
    }
    
    func testInitWithSequenceMultiple() {
        let rootDurationNode = DurationNode.with(Duration(1,8), sequence: [1,2,3,4])
        XCTAssert(rootDurationNode.children.count == 4)
    }
    
    func testInitWithSequenceDurationOfChildrenSingleEqualToRoot() {
        let rootDurationNode = DurationNode.with(Duration(1,8), sequence: [1])
        if let firstChild = rootDurationNode.children.first as? DurationNodeIntervalEnforcing {
            XCTAssert(firstChild.duration == Duration(1,8))
        } else {
            XCTFail()
        }
    }
    
    func testInitWithSequenceDurationOfChildrenDoubleHalfOfRoot() {
        let rootDurationNode = DurationNode.with(Duration(1,8), sequence: [1,1])
        if let children = rootDurationNode.children as? [DurationNodeIntervalEnforcing] {
            XCTAssert(children.first!.duration == Duration(1,16))
            XCTAssert(children.second!.duration == Duration(1,16))
        } else {
            XCTFail()
        }
    }
    
    func testInitWithSequenceDurationOfChildrenTriplet() {
        let rootDurationNode = DurationNode.with(Duration(1,8), sequence: [1,1,1])
        if let children = rootDurationNode.children as? [DurationNodeIntervalEnforcing] {
            var tripletDuration = Duration(1,16)
            tripletDuration.scale = (2/3)
            children.forEach {
                XCTAssert($0.duration == tripletDuration)
            }
        } else {
            XCTFail()
        }
    }
    
    func testAddChildWithBeatsSingle() {
        let rootDurationNode = DurationNode.with(1,8)
        rootDurationNode.addChildWith(1)
        if let child = rootDurationNode.children.first as? DurationNodeIntervalEnforcing {
            XCTAssert(child.duration == Duration(1,8))
        } else {
            XCTFail()
        }
    }
    
    func testAddChildWithBeatsMultiple() {
        let rootDurationNode = DurationNode.with(1,8)
        rootDurationNode.addChildWith(1)
        rootDurationNode.addChildWith(1)
        rootDurationNode.addChildWith(1)
        if let children = rootDurationNode.children as? [DurationNodeIntervalEnforcing] {
            var tripletDuration = Duration(1,16)
            tripletDuration.scale = (2/3)
            children.forEach {
                print("child duration: \($0.duration)")
                XCTAssert($0.duration == tripletDuration)
            }
        } else {
            XCTFail()
        }
    }
    
    func testDurationMatching_7_8() {
        let rootDurationNode = DurationNode.with(4,8)
        rootDurationNode.addChildWith(1)
        rootDurationNode.addChildWith(2)
        rootDurationNode.addChildWith(2)
        rootDurationNode.addChildWith(2)
        if let firstChild = rootDurationNode.children.first as? DurationNodeIntervalEnforcing {
            XCTAssert(firstChild.duration.beats!.amount == 1)
            XCTAssert(firstChild.duration.subdivision!.value == 16)
        } else {
            XCTFail()
        }
    }
}
