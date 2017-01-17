//
//  StaffClefTests.swift
//  Staff
//
//  Created by James Bean on 1/12/17.
//
//

import XCTest
import Pitch
import PitchSpellingTools
@testable import Staff

//class StaffClefTests: XCTestCase {
//
//    func testStaffSlothMiddleC() {
//        let middleC = SpelledPitch(60, PitchSpelling(.c))
//        XCTAssertEqual(slot(middleC, .bass), 6)
//        XCTAssertEqual(slot(middleC, .tenor), 2)
//        XCTAssertEqual(slot(middleC, .alto), 0)
//        XCTAssertEqual(slot(middleC, .treble), -6)
//    }
//    
//    func testStaffSlotEFlatAboveMiddleC() {
//        let eFlat = SpelledPitch(63, PitchSpelling(.e, .flat))
//        XCTAssertEqual(slot(eFlat, .bass), 8)
//        XCTAssertEqual(slot(eFlat, .tenor), 4)
//        XCTAssertEqual(slot(eFlat, .alto), 2)
//        XCTAssertEqual(slot(eFlat, .treble), -4)
//    }
//    
//    func testStaffSlotASharpTwoOctavesBelowMiddleC() {
//        let eFlat = SpelledPitch(46, PitchSpelling(.a, .sharp))
//        XCTAssertEqual(slot(eFlat, .bass), -3)
//        XCTAssertEqual(slot(eFlat, .tenor), -7)
//        XCTAssertEqual(slot(eFlat, .alto), -9)
//        XCTAssertEqual(slot(eFlat, .treble), -15)
//    }
//    
//    func testStaffSlotDSharpTwoOctavesAboveMiddleC() {
//        let dSharp = SpelledPitch(87, PitchSpelling(.d, .sharp))
//        XCTAssertEqual(slot(dSharp, .bass), 21)
//        XCTAssertEqual(slot(dSharp, .tenor), 17)
//        XCTAssertEqual(slot(dSharp, .alto), 15)
//        XCTAssertEqual(slot(dSharp, .treble), 9)
//    }
//}
