//
//  StringNodeTests.swift
//  DNMModel
//
//  Created by James Bean on 1/9/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class StringNodeTests: XCTestCase {
    
    func testPosition() {
        let stringNode = StringNode(
            fundamentalPitch: Pitch(midi: MIDI(36)), partialNumber: 7, partialInstance: 3
        )
        XCTAssert(stringNode.position == (3/7))
    }
    
    func testSoundingPitch2() {
        let stringNode = StringNode(
            fundamentalPitch: Pitch(midi: MIDI(36)), partialNumber: 2, partialInstance: 1
        )
        XCTAssert(stringNode.soundingPitch == Pitch(midi: MIDI(48)))
    }
    
    func testSoundingPitch3() {
        let stringNode = StringNode(
            fundamentalPitch: Pitch(midi: MIDI(36)), partialNumber: 3, partialInstance: 2
        )
        var midiResult = stringNode.soundingPitch.midi
        midiResult.quantizeToResolution(1)
        XCTAssert(midiResult == MIDI(55))
    }
    
    func testFingeredPitch2() {
        let stringNode = StringNode(
            fundamentalPitch: Pitch(midi: MIDI(36)), partialNumber: 2, partialInstance: 1
        )
        XCTAssert(stringNode.fingeredPitch == Pitch(midi: MIDI(48)))
    }
    
    func testFingeredPitch3_1() {
        let stringNode = StringNode(
            fundamentalPitch: Pitch(midi: MIDI(36)), partialNumber: 3, partialInstance: 1
        )
        var midiResult = stringNode.fingeredPitch.midi
        midiResult.quantizeToResolution(1)
        XCTAssert(midiResult == MIDI(43))
    }
    
    func testFingeredPitch3_2() {
        let stringNode = StringNode(
            fundamentalPitch: Pitch(midi: MIDI(36)), partialNumber: 3, partialInstance: 2
        )
        var midiResult = stringNode.fingeredPitch.midi
        midiResult.quantizeToResolution(1)
        XCTAssert(midiResult == MIDI(55))
    }
    
    // touch fourth harmonic
    func testFingeredPitch4() {
        let stringNode = StringNode(
            fundamentalPitch: Pitch(midi: MIDI(36)), partialNumber: 4, partialInstance: 1
        )
        var midiResult = stringNode.fingeredPitch.midi
        midiResult.quantizeToResolution(1)
        XCTAssert(midiResult == MIDI(41))
    }
}
