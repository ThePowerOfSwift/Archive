//
//  StringModelsTests.swift
//  DNMModel
//
//  Created by James Bean on 1/9/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class StringModelsTests: XCTestCase {

    func testNodesForPartial3() {
        let fundamentalPitch = Pitch(midi: MIDI(36))
        let string = StringModel(fundamentalPitch: fundamentalPitch)
        let nodes = [
            StringNode(fundamentalPitch: fundamentalPitch, partialNumber: 3, partialInstance: 1),
            StringNode(fundamentalPitch: fundamentalPitch, partialNumber: 3, partialInstance: 2)
        ]
        XCTAssert(string.nodesForPartial(3) == nodes)
    }
    
    func testNdoesForPartial9() {
        let fundamentalPitch = Pitch(midi: MIDI(36))
        let string = StringModel(fundamentalPitch: fundamentalPitch)
        let nodes = [
            StringNode(fundamentalPitch: fundamentalPitch, partialNumber: 9, partialInstance: 1),
            StringNode(fundamentalPitch: fundamentalPitch, partialNumber: 9, partialInstance: 2),
            StringNode(fundamentalPitch: fundamentalPitch, partialNumber: 9, partialInstance: 4),
            StringNode(fundamentalPitch: fundamentalPitch, partialNumber: 9, partialInstance: 5),
            StringNode(fundamentalPitch: fundamentalPitch, partialNumber: 9, partialInstance: 7),
            StringNode(fundamentalPitch: fundamentalPitch, partialNumber: 9, partialInstance: 8)
        ]
        XCTAssert(string.nodesForPartial(9) == nodes)
    }
}