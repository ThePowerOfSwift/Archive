//
//  ListProcessingTests.swift
//  ArrayTools
//
//  Created by Jeremy Corren on 11/3/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ArrayTools

class ListProcessingTests: XCTestCase {

    func testArraySliceHead() {
        let arraySlice: ArraySlice = [1]
        XCTAssertEqual(arraySlice.head, 1)
    }

    func testArraySliceTail() {
        let arraySlice: ArraySlice<Int> = [1,2,3]
        let tail: ArraySlice<Int> = [2,3]
        XCTAssertEqual(arraySlice.tail!, tail)
    }

    func testArraySliceTailNil() {
        let arraySlice: ArraySlice<Int> = []
        XCTAssertNil(arraySlice.tail)
    }

    func testArraySliceDestructured() {
        let arraySlice: ArraySlice<Int> = [1,2,3]
        let (a,b) = arraySlice.destructured!
        XCTAssertEqual(1, a)
        XCTAssertEqual([2,3], b)
    }

    func testArraySliceDestructuredNil() {
        let arraySlice: ArraySlice<Int> = []
        XCTAssertNil(arraySlice.destructured)
    }

    func testArrayHead() {
        let array: Array = [1]
        XCTAssertEqual(array.head, 1)
    }

    func testArrayTail() {
        let array: Array<Int> = [1,2,3]
        let tail: Array<Int> = [2,3]
        XCTAssertEqual(array.tail!, tail)
    }

    func testArrayTailNil() {
        let array: Array<Int> = []
        XCTAssertNil(array.tail)
    }

    func testArrayDestructured() {
        let array: Array<Int> = [1,2,3]
        let (a,b) = array.destructured!
        XCTAssertEqual(1, a)
        XCTAssertEqual([2,3], b)
    }

    func testArrayDestructuredNil() {
        let array: Array<Int> = []
        XCTAssertNil(array.destructured)
    }

    func testAddTail() {
        let head = 1
        let tail: Array<Int> = [2,3]
        XCTAssertEqual(head + tail, [1,2,3])
    }

    func testAddItem() {
        let array: Array<Int> = [1,2]
        let item = 3
        XCTAssertEqual(array + item, [1,2,3])
    }
}
