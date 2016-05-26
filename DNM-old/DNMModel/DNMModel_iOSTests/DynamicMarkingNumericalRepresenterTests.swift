//
//  DynamicMarkingNumericalRepresenterTests.swift
//  DNMModel
//
//  Created by James Bean on 12/28/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DynamicMarkingNumericalRepresenterTests: XCTestCase {


    func testPiano() {
        let representer = DynamicMarkingNumericalRepresenter(string: "p")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [-2])
    }
    
    func testPianissimo() {
        let representer = DynamicMarkingNumericalRepresenter(string: "pp")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [-3])
    }
    
    func testPianississississississississimo() {
        let representer = DynamicMarkingNumericalRepresenter(string: "pppppppppp")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [-11])
    }
    
    func testForte() {
        let representer = DynamicMarkingNumericalRepresenter(string: "f")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [2])
    }
    
    func testFortissimo() {
        let representer = DynamicMarkingNumericalRepresenter(string: "ff")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [3])
    }
    
    func testFortississississississississimo() {
        let representer = DynamicMarkingNumericalRepresenter(string: "ffffffffff")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [11])
    }
    
    func testMezzopiano() {
        let representer = DynamicMarkingNumericalRepresenter(string: "mp")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [-1])
    }
    
    func testMezzoforte() {
        let representer = DynamicMarkingNumericalRepresenter(string: "mf")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [1])
    }
    
    func testNiente() {
        let representer = DynamicMarkingNumericalRepresenter(string: "o")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [Int.min])
    }
    
    func testPianoForte() {
        let representer = DynamicMarkingNumericalRepresenter(string: "pf")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [-2,2])
    }
    
    func testFortePiano() {
        let representer = DynamicMarkingNumericalRepresenter(string: "fp")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [2,-2])
    }
    
    func testNienteForte() {
        let representer = DynamicMarkingNumericalRepresenter(string: "of")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [Int.min,2])
    }
    
    func testForteNiente() {
        let representer = DynamicMarkingNumericalRepresenter(string: "fo")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [2,Int.min])
    }
    
    func testNienteFortePiano() {
        let representer = DynamicMarkingNumericalRepresenter(string: "ofp")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [Int.min, 2, -2])
    }
    
    func testMezzoforteNiente() {
        let representer = DynamicMarkingNumericalRepresenter(string: "mfo")
        let intValue = try? representer.getNumericalRepresentation()
        XCTAssertNotNil(intValue)
        XCTAssertEqual(intValue!, [1, Int.min])
    }
}
