//
//  DurationNodeIntervalInferringTests.swift
//  DNMModel
//
//  Created by James Bean on 1/19/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationNodeIntervalInferringTests: XCTestCase {

    func testAddChildAtDurationSingle() {
        let rootDurationNode = DurationNodeIntervalInferring()
        rootDurationNode.addChildAt(Duration(1,8))
        if let child = rootDurationNode.children.first as? DurationNodeIntervalEnforcing {
            XCTAssert(child.durationInterval.startDuration == Duration(1,8))
        } else {
            XCTFail()
        }
    }
    
    func testDurationIntervalZeroForNoChildren() {
        let rootDurationNode = DurationNodeIntervalInferring()
        XCTAssert(rootDurationNode.durationInterval == DurationIntervalZero)
    }
    
    func testDurationInterval() {
        let rootDurationNode = DurationNodeIntervalInferring()
        rootDurationNode.addChildAt(Duration(1,8))
        rootDurationNode.addChildAt(Duration(7,8))
        XCTAssert(rootDurationNode.durationInterval == "1,8 -> 7,8")
    }
    
    func testSortChildren() {
        let rootDurationNode = DurationNodeIntervalInferring()
        rootDurationNode.addChildAt(Duration(7,8))
        rootDurationNode.addChildAt(Duration(1,8))
        if let firstChild = rootDurationNode.children.first as? DurationNodeIntervalEnforcing,
            let secondChild = rootDurationNode.children.second as? DurationNodeIntervalEnforcing
        {
            XCTAssert(firstChild.durationInterval.startDuration == Duration(1,8))
            XCTAssert(secondChild.durationInterval.startDuration == Duration(7,8))
        } else {
            XCTFail()
        }
    }
    
    func testDurationsOfChildren() {
        let rootDurationNode = DurationNodeIntervalInferring()
        rootDurationNode.addChildAt(Duration(1,8))
        rootDurationNode.addChildAt(Duration(7,8))
        if let firstChild = rootDurationNode.children.first as? DurationNodeIntervalEnforcing {
            XCTAssert(firstChild.durationInterval == "1,8 -> 7,8")
        } else {
            XCTFail()
        }
    }
}
