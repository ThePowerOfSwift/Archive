//
//  OrderedDictionaryTests.swift
//  DNMModel
//
//  Created by James Bean on 11/23/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class OrderedDictionaryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let od = OrderedDictionary<Int, Int>()
        XCTAssert(od.count == 0, "shouldn't have anything in it yet")
    }
    
    func testSubscript() {
        var od = OrderedDictionary<String, String>()
        od["first"] = "numberOne"
        XCTAssert(od.count == 1, "should have one value")
        XCTAssert(od["first"] == "numberOne", "first value should be numberOne")
        // more?
    }
    
    func testOverrideVal() {
        var od = OrderedDictionary<String, String>()
        
        // set initial val
        od["first"] = "numberOneStunna"
        
        // override val
        od["first"] = "realMcCoy"
        XCTAssert(od["first"] == "realMcCoy", "still stunning though")
        
        od["first"] = nil
        XCTAssert(od["first"] == nil, "no more stunning allowed")
    }
    
    func testAppendContentsOnOrderedDictionary() {
        var od0 = OrderedDictionary<String, String>()
        od0["first"] = "numberOne"
        od0["second"] = "numberTwo"
        
        var od1 = OrderedDictionary<String, String>()
        od1["third"] = "numberThree"
        od1["fourth"] = "numberFour"
        
        od0.appendContentsOfOrderedDictionary(od1)
        XCTAssert(od0.count == 4, "should have four vals")
        XCTAssert(od1.count == 2, "shouldn't have changed")
        XCTAssert(od0["third"] == "numberThree", "should be this")
        XCTAssert(od0["fourth"] == "numberFour", "should be this")
        
        // not addressing order
    }
    
    func testSequenceType() {
        var od = OrderedDictionary<String, String>()
        od["first"] = "numberOne"
        od["second"] = "numberTwo"
        od["third"] = "numberThree"
        od["fourth"] = "numberFour"
        
        var keys: [String] = []
        var vals: [String] = []
        
        for (k,v) in od {
            keys.append(k)
            vals.append(v)
        }
        
        XCTAssert(keys == ["first", "second", "third", "fourth"], "keys wrong")
        XCTAssert(vals == ["numberOne", "numberTwo", "numberThree", "numberFour"], "vals wrong")
    }
    
    func testEquatable() {
        var od0 = OrderedDictionary<String, String>()
        od0["first"] = "numberOne"
        od0["second"] = "numberTwo"
        od0["third"] = "numberThree"
        od0["fourth"] = "numberFour"
        
        var od1 = OrderedDictionary<String, String>()
        od1["first"] = "numberOne"
        od1["second"] = "numberTwo"
        od1["third"] = "numberThree"
        od1["fourth"] = "numberFour"
        
        XCTAssert(od0 == od1, "should be ==")
        
        od1["first"] = nil
        XCTAssert(od0 != od1, "should be !=")
        
        // test order not preserved: should be !=
        od1["first"] = "numberOne"
        XCTAssert(od0 != od1, "should be !=")
        
        od1["first"] = nil
        XCTAssert(od0 != od1, "should be !=")
        
        // test order preserved
        od1.insertValue("numberOne", forKey: "first", atIndex: 0)
        XCTAssert(od0 == od1, "should be ==")
    }
}
