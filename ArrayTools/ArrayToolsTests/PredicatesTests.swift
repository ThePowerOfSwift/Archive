//
//  PredicatesTests.swift
//  ArrayTools
//
//  Created by James Bean on 5/27/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ArrayTools

struct S { let value: Int }
extension S: Equatable { }
func == (lhs: S, rhs: S) -> Bool { return lhs.value == rhs.value }

class PredicatesTests: XCTestCase {
    
    let structs = [S(value: 1), S(value: 3), S(value: 2), S(value: 3)]
    
    func testAllSatisfyTrue() {
        let array = [1,1,1,1,1,1,1,1]
        XCTAssertTrue(array.allSatisfy { $0 == 1 })
    }
    
    func testAllSatisfyFalse() {
        let array = [1,2,3,4,5,6,7,8,9]
        XCTAssertFalse(array.allSatisfy { $0 == 1})
    }
    
    func testAnySatisfyTrue() {
        let array = [3,1,2,6]
        XCTAssertTrue(array.anySatisfy { $0 == 2 })
    }
    
    func testAnySatisfyFalse() {
        let array = [1,2,3,4,5,6,7,8,9]
        XCTAssertFalse(array.anySatisfy { $0 == 10 })
    }
    
    func testExtremeElementsGreatest() {
        let greatest = structs.extremeElements(>) { $0.value }
        XCTAssertEqual(greatest, [S(value: 3), S(value: 3)])
    }
    
    func testExtremeElementsLeast() {
        let least = structs.extremeElements(<) { $0.value }
        XCTAssertEqual(least, [S(value: 1)])
    }
    
    func testGreatest() {
        let greatest = structs.greatest { $0.value }
        XCTAssertEqual(greatest, 3)
    }
    
    func testLeast() {
        let least = structs.least { $0.value }
        XCTAssertEqual(least, 1)
    }
    
    func testExtremityEmptyNil() {
        let array: [S] = []
        XCTAssertNil(array.extremity(>) { $0.value })
    }
    
    func testExtremeElementsNil() {
        let array: [S] = []
        XCTAssertEqual(array.extremeElements(<) { $0.value }, [])
    }
}

