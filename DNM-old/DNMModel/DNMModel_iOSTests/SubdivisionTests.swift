//
//  SubdivisionTests.swift
//  Duration
//
//  Created by James Bean on 3/13/15.
//  Copyright (c) 2015 James Bean. All rights reserved.
//

import UIKit
import XCTest
@testable import DNMModel

class SubdivisionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSubdivision() {
        var subdivision: Subdivision = Subdivision(value: 64)
        XCTAssert(subdivision.value == 64, "subdivision value not 64")
        XCTAssert(subdivision.level == 4, "subdivision level not 4")
        subdivision.setValue(128)
        XCTAssert(subdivision.level == 5, "subdivision.value not 5")
        subdivision.setLevel(2)
        XCTAssert(subdivision.level == 2, "subdivision.level not 2")
        XCTAssert(subdivision.value == 16, "subdivision.value = 16")
    }
    
    func testSubdivisionCompare() {
        var s1 = Subdivision(value: 64)
        let s2 = Subdivision(level: 4)
        XCTAssert(s1 == s2, "equiv subdivisions not equiv")
        XCTAssert(s1 <= s2, "equiv subdivision not less than or equal")
        s1.setValue(32)
        XCTAssert(s1 <= s2, "lesser subdivision not less than or equal")
        XCTAssert(s1 < s2, "lesser subd not lesser")
        XCTAssert(s2 > s1, "greater subd not greater")
        XCTAssert(s1 != s2, "non equiv subd equiv")
    }
    
    func testSubdivisionMultiplyDivide() {
        let s1 = Subdivision(value: 32)
        let s2 = s1 * 2
        XCTAssert(s2.value == 64, "s2.value not 64")
        var s3 = s2 / 4
        XCTAssert(s3.value == 16, "s3.value not 16")
        s3 *= 2
        XCTAssert(s3.value == 32, "s3.value not 32")
        s3 /= 4
        XCTAssert(s3.value == 8, "s3.value not 8")
    }
}