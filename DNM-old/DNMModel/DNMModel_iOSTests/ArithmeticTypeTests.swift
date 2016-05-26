//
//  ArithmeticTypeTests.swift
//  DNMModel
//
//  Created by James Bean on 1/8/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class ArithmeticTypeTests: XCTestCase {

    func testGCDInt() {
        let a: Int = 4
        let b: Int = 6
        XCTAssertEqual(gcd(a, b), 2)
    }
    
    func testGCDFloat() {
        let a: Float = 4.0
        let b: Float = 6.0
        XCTAssertEqual(gcd(a, b), 2.0)
    }
    
    func testGCDDouble() {
        let a: Double = 4.0
        let b: Double = 6.0
        XCTAssertEqual(gcd(a, b), 2.0)
    }
    
    func testGCDAGreaterThanB() {
        let a: Int = 6
        let b: Int = 4
        XCTAssertEqual(gcd(a, b), 2)
    }
    
    func testGCDOne() {
        let a: Int = 7
        let b: Int = 9
        XCTAssertEqual(gcd(a, b), 1)
    }
    
    func testGCDArrayOfInt1() {
        let array: [Int] = [2,4,6,4]
        if let gcd: Int = array.greatestCommonDivisor() {
            XCTAssertEqual(gcd, 2)
        } else {
            XCTFail()
        }
    }
    
    func testGCDArrayOfInt2() {
        let array: [Int] = [4,8,12,16,4]
        if let gcd: Int = array.greatestCommonDivisor() {
            XCTAssertEqual(gcd, 4)
        } else {
            XCTFail()
        }
    }
    
    func testIntIsPrime1() {
        let i = 1
        XCTAssert(!i.isPrime)
    }
    
    func testIntIsPrime2() {
        let i = 2
        XCTAssert(i.isPrime)
    }
    
    func testIntIsPrime3() {
        let i = 3
        XCTAssert(i.isPrime)
    }
    
    func testIntIsPrime4() {
        let i = 4
        XCTAssert(!i.isPrime)
    }
    
    func testIntIsPrimeMany() {
        var i = 5
        XCTAssert(i.isPrime)
        i = 6
        XCTAssert(!i.isPrime)
        i = 7
        XCTAssert(i.isPrime)
        i = 9
        XCTAssert(!i.isPrime)
    }
}
