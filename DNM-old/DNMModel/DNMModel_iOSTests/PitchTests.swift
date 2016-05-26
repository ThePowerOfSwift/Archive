
//
//  PitchTests.swift
//  DNMModel_iOSTests
//
//  Created by James Bean on 3/17/15.
//  Copyright (c) 2015 James Bean. All rights reserved.
//

import UIKit
import XCTest
@testable import DNMModel

class PitchTests: XCTestCase {
    
    func testPossibleSpellings() {
        var p: Float = 60.0
        while p < 72 {
            let pitch = Pitch(midi: MIDI(p))
            print(pitch.possibleSpellings)
            p += 0.25
        }
    }
    
    func testMiddleC() {
        let middleC = Pitch.middleC()
        XCTAssert(middleC.midi.value == 60.0, "should be 60")
    }

    func testInit() {
        let pM = Pitch(midi: MIDI(69.0))
        XCTAssert(pM.midi.value == 69.0, "midi not set correctly")
        XCTAssert(pM.frequency.value == 440, "frequency not set correctly")
    }
    
    func testInitWithStringEmpty() {
        let string = ""
        let pitch = Pitch(string: string)
        XCTAssert(pitch == nil)
    }
    
    func testInitWithStringInvalidLetterName() {
        ["h", "i", "j", "X", "Z", "T"].forEach {
            let pitch = Pitch(string: $0)
            XCTAssert(pitch == nil)
        }
    }
    
    func testInitWithValidLetterName() {
        ["a","b","c","d","e","f","g","A","B","C","D","E","F","G"].forEach {
            let pitch = Pitch(string: $0)
            XCTAssert(pitch != nil)
        }
    }
    
    func testInitWithStringHalfTonesInvalid() {
        ["cd", "c$", "d!", "do", "d.", "g-", "g+"].forEach {
            let pitch = Pitch(string: $0)
            XCTAssert(pitch == nil)
        }
    }
    
    func testInitWithStringHalfTonesValid() {
        ["cs", "c#", "db", "ds", "d#", "gb", "g#"].forEach {
            let pitch = Pitch(string: $0)
            XCTAssert(pitch != nil)
        }
    }
    
    func testInitWithStringOctave4() {
        let string = "eb4"
        let pitch = Pitch(string: string)
        XCTAssert(pitch != nil)
        XCTAssert(pitch! == Pitch(midi: MIDI(63)))
    }

    func testInitWithStringOctave5() {
        let string = "d#5"
        let pitch = Pitch(string: string)
        XCTAssert(pitch != nil)
        XCTAssert(pitch! == Pitch(midi: MIDI(75)))
    }
    
    func testInitWithStringOctave3() {
        let string = "b3"
        let pitch = Pitch(string: string)
        XCTAssert(pitch != nil)
        XCTAssert(pitch! == Pitch(midi: MIDI(59)))
    }
    
    func testInitWithStringEQuarterFlat() {
        ["eqb", "e_qb"].forEach {
            let pitch = Pitch(string: $0)
            XCTAssert(pitch == Pitch(midi: MIDI(63.5)))
        }
    }
    
    func testInitWithStringEQuarterSharp() {
        ["eqs","eq#","e_q#","e_qs"].forEach {
            let pitch = Pitch(string: $0)
            XCTAssert(pitch == Pitch(midi: MIDI(64.5)))
        }
    }
    
    func testInitWithStringEQuarterSharp6() {
        ["eqs6","e_qs_6", "eq#6", "e_q#_6"].forEach {
            let pitch = Pitch(string: $0)
            XCTAssert(pitch == Pitch(midi: MIDI(88.5)))
        }
    }
    
    func testInitWithStringGQuarterFlatDown5() {
        ["gqbdown5", "g_qb_down_5"].forEach {
            let pitch = Pitch(string: $0)
            XCTAssert(pitch == Pitch(midi: MIDI(78.25)))
        }
    }
    
    func testInitWithStringAQuarterSharpUp4() {
        ["a#up4","asup","a_#_up","a_s_up4"].forEach {
            let pitch = Pitch(string: $0)
            XCTAssert(pitch == Pitch(midi: MIDI(70.25)))
        }
    }
    
    func testComparison() {
        let p0 = Pitch(midi: MIDI(60))
        let p1 = Pitch(midi: MIDI(60.25))
        XCTAssert(p1 >= p0, "should be >=")
    }
    
    func testGetMIDIOfPartial() {
        let p = Pitch(midi: MIDI(60))
        let p8va = p.midiForPartial(2)
        XCTAssert(p8va.value == 72, "midi of partial (2) incorrect")
    }
    
    func testGetFrequencyOfPartial() {
        let p = Pitch(midi: MIDI(69.0))
        let p8va = p.frequencyForPartial(2)
        XCTAssert(p8va.value == 880.0, "freq of partial (2) incorrect")
    }
    
    func testPitchClass() {
        let p = Pitch(midi: MIDI(69.0))
        XCTAssert(p.pitchClass.midi.value == 9.0, "pitchClass not set correctly")
    }
    
    func testResolution() {
        let chromatic = Pitch(midi: MIDI(60.0))
        XCTAssert(chromatic.resolution == 1.0, "resolution incorrect")
        let quarterTone = Pitch(midi: MIDI(60.5))
        XCTAssert(quarterTone.resolution == 0.5, "resolution incorrect")
        let eighthTone = Pitch(midi: MIDI(60.25))
        XCTAssert(eighthTone.resolution == 0.25, "resolution incorrect")
    }
    
    func testOctave() {
        let pitches: [Float] = [60, 61, 59, 48, 72, 84]
        let octaves: [Int] = [4, 4, 3, 3, 5, 6]
        var index: Int = 0
        while index < pitches.count {
            let pitch = Pitch(midi: MIDI(pitches[index]))
            XCTAssert(pitch.octave == octaves[index], "octave incorrect")
            index++
        }
    }
    
    func testRandom() {
        for _ in 0..<50 {
            let pitch: Pitch = Pitch.random()
            print(pitch)
        }
        
        for _ in 0..<50 {
            let pitch: Pitch = Pitch.random(36.0, max: 50.0, resolution: 0.5)
            print(pitch)
        }
        
        let pitches = Pitch.random(10, min: 30, max: 90, resolution: 0.25)
        for p in pitches {
            print(p)
        }
    }
    
    func testRandomArray() {
        let randomPitches: [Pitch] = Pitch.random(5)
        print(randomPitches)
    }
}