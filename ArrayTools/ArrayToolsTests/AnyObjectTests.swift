//
//  AnyObjectTests.swift
//  ArrayTools
//
//  Created by Jeremy Corren on 10/27/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ArrayTools

class AnyObjectTests: XCTestCase {

    func testContains() {
        let object = 1 as AnyObject
        let array: [AnyObject] = [object]
        XCTAssertTrue(array.contains(object))
    }

    func testContainsFalse() {
        let object = 1 as AnyObject
        let array: [AnyObject] = []
        XCTAssertFalse(array.contains(object))
    }

    func testIndex() {
        let object = 1 as AnyObject
        let object2 = 2 as AnyObject
        let array: [AnyObject] = [object, object2]
        XCTAssertEqual(array.index(ofObject: object2), 1)
    }

    func testIndexNil() {
        let object = 1 as AnyObject
        let array: [AnyObject] = []
        XCTAssertNil(array.index(ofObject: object))
    }

    func testRemove() {
        let object = 1 as AnyObject
        var array: [AnyObject] = [object]
        do {
            try array.remove(object)
            XCTAssertNil(array.index(ofObject: object))
        } catch _ {
            XCTFail()
        }
    }

    func testRemoveEmpty() {
        let object = 1 as AnyObject
        var array: [AnyObject] = []
        do {
            try array.remove(object)
        } catch ArrayError.removalError {
            // Success
        } catch _ {
            XCTFail()
        }
    }
}
