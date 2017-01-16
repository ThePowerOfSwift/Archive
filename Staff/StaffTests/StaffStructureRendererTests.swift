//
//  StaffStructureRendererTests.swift
//  Staff
//
//  Created by James Bean on 1/12/17.
//
//

import XCTest
import Staff

class StaffStructureRendererTests: XCTestCase {

    func testStartLines() {
        var renderer = StaffStructureRenderer()
        renderer.startLines(at: 100)
    }
    
    func testStopLines() {
        var renderer = StaffStructureRenderer()
        renderer.stopLines(at: 100)
    }
    
    func testStartAndStop() {
        var renderer = StaffStructureRenderer()
        renderer.startLines(at: 0)
        renderer.stopLines(at: 100)
    }
    
    func testAddLedgerLinesAbove() {
        var renderer = StaffStructureRenderer()
        renderer.addLedgerLinesBelow(at: 100, amount: 4)
    }
    
    func testAddLedgerLinesBelow() {
        var renderer = StaffStructureRenderer()
        renderer.addLedgerLinesAbove(at: 100, amount: 2)
    }
    
    func testLinesPath() {
        let config = StaffStructureConfiguration()
        var renderer = StaffStructureRenderer()
        renderer.startLines(at: 0)
        renderer.stopLines(at: 100)
        renderer.render(in: CALayer(), with: config)
    }
}
