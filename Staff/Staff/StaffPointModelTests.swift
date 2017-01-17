//
//  StaffPointModelTests.swift
//  Staff
//
//  Created by James Bean on 1/14/17.
//
//

import XCTest
import Pitch
import PitchSpellingTools
import Staff

//class StaffPointModelTests: XCTestCase {
//
//    let treble = StaffClef(.treble)
//    let bass = StaffClef(.bass)
//    
//    func staffPoint(_ pitchSet: PitchSet) -> StaffPointModel {
//        let spelled = pitchSet.map { try! $0.spelledWithDefaultSpelling() }
//        let representable = spelled.map { StaffRepresentablePitch($0, .ord) }
//        return StaffPointModel(representable)
//    }
//    
//    func testInit() {
//        let pitchSet: PitchSet = [60,61,62,63]
//        let spelled = pitchSet.map { try! $0.spelledWithDefaultSpelling() }
//        let representable = spelled.map { StaffRepresentablePitch($0, .ord) }
//        _ = StaffPointModel(representable)
//    }
//    
//    func testLedgerLinesAboveAndBelowEmpty() {
//        
//        let staffPoint = StaffPointModel([])
//        XCTAssertEqual(staffPoint.ledgerLines(treble), (0,0))
//        //XCTAssertEqual(staffPoint.ledgerLinesAbove(bass), 0)
//    }
//    
//    func testLedgerLinesAboveMonadInStaff() {
//        let point = staffPoint([71])
//        XCTAssertEqual(point.ledgerLinesAbove(treble), 0)
//    }
//    
//    func testLedgerLinesBelowMonadInStaff() {
//        
//        let point = staffPoint([48])
//        XCTAssertEqual(point.ledgerLinesBelow(bass), 0)
//    }
//    
//    func testLedgerLinesAboveMonadJustAboveNoLedgerLines() {
//        
//        let point = staffPoint([79])
//        XCTAssertEqual(point.ledgerLinesBelow(treble), 0)
//    }
//    
//    func testLedgerLinesBelowMonadJustBelowNoLedgerLines() {
//        
//        let point = staffPoint([41])
//        XCTAssertEqual(point.ledgerLinesBelow(bass), 0)
//    }
//    
//    func testLedgerLinesMonadOneAbove() {
//        let point = staffPoint([60])
//        XCTAssertEqual(point.ledgerLinesAbove(bass), 1)
//    }
//    
//    func testLedgerLinesMonadOneBelow() {
//        let point = staffPoint([60])
//        XCTAssertEqual(point.ledgerLinesBelow(treble), 1)
//    }
//    
//    func testLedgerLinesDyadSingleAboveAndBelow() {
//        let point = staffPoint([60, 81])
//        XCTAssertEqual(point.ledgerLinesBelow(treble), 1)
//        XCTAssertEqual(point.ledgerLinesAbove(treble), 1)
//    }
//    
//    func testManyPitchesOnlySeveralLinesAboveDNatural() {
//        let point = staffPoint([64,66,67,69,86])
//        XCTAssertEqual(point.ledgerLinesBelow(treble), 0)
//        XCTAssertEqual(point.ledgerLinesAbove(treble), 2)
//    }
//}
