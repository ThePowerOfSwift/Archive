//
//  Pitch.swift
//  DNMModel
//
//  Created by James Bean on 8/11/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
Pitch
*/
public class Pitch: Equatable {
    
    // MARK: - Attributes
    
    /// MIDI representation of Pitch (middle-c = 60.0, C5 = 72.0, C3 = 48.0, etc)
    public var midi: MIDI
    
    /// Frequency representation of Pitch (middle-c = 261.6)
    public var frequency: Frequency
    
    /// Modulo 12 representation of Pitch // dedicated class?
    public var pitchClass: PitchClass { return PitchClass(midi: MIDI(midi.value % 12.0)) }
    
    /// Resolution of Pitch (1.0 = chromatic, 0.5 = 1/4-tone, 0.25 = 1/8-tone)
    public var resolution: Float {
        return midi.value % 1 == 0 ? 1.0 : midi.value % 0.5 == 0 ? 0.5 : 0.25
    }
    
    /// Octave of Pitch
    public var octave: Int { get { return getOctave() } }
    
    // MARK: Spelling a Pitch
    
    /// PitchSpelling of Pitch, if it has been spelled.
    public var spelling: PitchSpelling?
    
    /// All possible PitchSpellings of Pitch
    public var possibleSpellings: [PitchSpelling] {
        return PitchSpelling.pitchSpellingsForPitch(pitch: self)
    }
    
    /// Check if this Pitch has been spelled
    public var hasBeenSpelled: Bool { return spelling != nil }
    
    // NYI: Create random pitch with Frequency
    
    /**
    Creates a random pitch within sensible values.
    
    - returns: Pitch with random value
    */
    public static func random() -> Pitch {
        let randomMIDI: Float = randomFloat(min: 60, max: 79, resolution: 0.25)
        return Pitch(midi: MIDI(randomMIDI))
    }
    
    /**
    Creates a pitch within range and with resolution decided by user
    
    - parameter min:        Minimum MIDI value
    - parameter max:        Maximum MIDI value
    - parameter resolution: Resolution of Pitch (1.0: Half-tone, 0.5: Quarter-tone, 0.25: Eighth-tone)
    
    - returns: Pitch within range and resolution decided by user
    */
    public static func random(min: Float, max: Float, resolution: Float) -> Pitch {
        let randomMIDI: Float = randomFloat(min: min, max: max, resolution: resolution)
        return Pitch(midi: MIDI(randomMIDI))
    }
    
    /**
    Creates an array of pitches with random values
    
    - parameter amount: Amount of pitches desired
    
    - returns: Array of pitches with random values
    */
    public static func random(amount: Int) -> [Pitch] {
        var pitches: [Pitch] = []
        for _ in 0..<amount { pitches.append(Pitch.random()) }
        return pitches
    }
    
    /**
     Generate randomPitch
     
     - parameter amount:     Amount of Pitches
     - parameter min:        Minimum MIDI value
     - parameter max:        Maximum MIDI value
     - parameter resolution: Resolution of Pitches
     
     - returns: Array of Pitches with given constraints
     */
    public static func random(amount: Int, min: Float, max: Float, resolution: Float)
        -> [Pitch]
    {
        var pitches: [Pitch] = []
        for _ in 0..<amount {
            pitches.append(Pitch.random(min, max: max, resolution: resolution))
        }
        return pitches
    }
    
    /**
     MiddleC Pitch
     
     - returns: MiddleC Pitch
     */
    public static func middleC() -> Pitch {
        return Pitch(midi: MIDI(60))
    }
    
    // MARK: Create a Pitch
    
    /**
    Create a Pitch with MIDI value and optional resolution.
    
    - parameter midi:       MIDI representation of Pitch (middle-c = 60.0, C5 = 72.0, C3 = 48.0)
    - parameter resolution: Resolution of returned MIDI. Default is nil (objective resolution).
    (1 = chromatic, 0.5 = 1/4-tone resolution, 0.25 = 1/8-tone resolution)
    
    - returns: Initialized Pitch object
    */
    public init(midi: MIDI, resolution: Float? = nil) {
        self.midi = MIDI(value: midi.value, resolution: resolution)
        self.frequency = Frequency(midi: midi)
    }
    
    /**
    Create a Pitch with Frequency and optional resolution
    
    - parameter frequency:  Frequency representation of Pitch
    - parameter resolution: Resolution of returned MIDI. Default is nil (objective resolution).
    (1 = chromatic, 0.5 = 1/4-tone resolution, 0.25 = 1/8-tone resolution)
    
    - returns: Initialized Pitch object
    */
    public init(frequency: Frequency, resolution: Float? = nil) {
        var m = MIDI(frequency: frequency)
        if let resolution = resolution { m.quantizeToResolution(resolution) }
        self.midi = m
        self.frequency = Frequency(midi: m)
    }
    
    // TODO: init(var string: String, andEnforceSpelling shouldEnforceSpelling: Bool) throws
    // move this to DNMParser, and call it from there... get it outta here!
    
    /**
    Create a Pitch with String.
    - Defaults: octave starting at middle-c (c4), natural
    - Specify sharp: "#" or "s"
    - Specify flat: "b"
    - Specify quarterSharp: "q#", "qs"
    - Specify quarterFlat: "qf"
    - Specify eighthTones: "gup", "d_qf_down_7", etc
    - Underscores are ignored, and helpful for visualization
    
    For example:
    - "c" or "C" = middleC
    - "d#","ds","ds4","d_s_4" = midi value 63.0 ("d sharp" above middle c)
    - "eqb5","e_qf_5" = midi value 75.5
    - "eb_up" = midi value 63.25
    
    - parameter string: String representation of Pitch
    
    - returns: Initialized Pitch object if you didn't fuck up the formatting of the String.
    */
    public convenience init?(string: String) {
        guard let midi = PitchParser().parse(string) as? Float else { return nil }
        self.init(midi: MIDI(midi))
        
        /*
        if let midi = midiFloatWithString(string) {
            self.init(midi: MIDI(midi))
        } else {
            return nil
        }
        */
    }
    
    /**
    Set PitchSpelling of Pitch
    
    - parameter pitchSpelling: PitchSpelling
    
    - returns: Pitch object
    */
    public func setPitchSpelling(pitchSpelling: PitchSpelling) {
        self.spelling = pitchSpelling
    }
    
    /**
    Clear pitch spelling, if present
    */
    public func clearPitchSpelling() {
        self.spelling = nil
    }
    
    // MARK: -  Operations
    
    // MARK: Get information of partials of Pitch
    
    // TODO: implement resolution
    public func pitchForPartial(partial: Int, resolution: Float? = nil) -> Pitch {
        return Pitch(frequency: frequency * Float(partial), resolution: resolution)
    }
    
    // TODO: implement resolution
    /**
    Get MIDI representation of partial of Pitch
    
    - parameter partial:    Desired partial
    - parameter resolution: Resolution of returned MIDI. Default is nil (objective resolution).
    (1 = chromatic, 0.5 = 1/4-tone resolution, 0.25 = 1/8-tone resolution)
    
    - returns: MIDI representation of partial
    */
    public func midiForPartial(partial: Int, resolution: Float? = nil) -> MIDI {
        var midi = MIDI(frequency: frequency * Float(partial))
        if let resolution = resolution { midi.quantizeToResolution(resolution) }
        return midi
    }
    
    // TODO: implement resolution
    /**
    Get Frequency representation of partial of Pitch
    
    - parameter partial:    Desired partial
    - parameter resolution: Resolution of returned MIDI. Default is nil (objective resolution).
    (1 = chromatic, 0.5 = 1/4-tone resolution, 0.25 = 1/8-tone resolution)
    
    - returns: Frequency representation of partial
    */
    public func frequencyForPartial(partial: Int, resolution: Float? = nil) -> Frequency {
        return frequency * Float(partial)
    }
    
    internal func getOctave() -> Int {
        var octave = Int(floor(midi.value / 12)) - 1
        if spelling != nil {
            if spelling!.letterName == .C && spelling!.coarse == 0 && spelling!.fine == -0.25 {
                octave += 1
            }
            else if spelling!.letterName == .C && spelling!.coarse == -0.5 { octave += 1 }
        }
        return octave
    }
}

// MARK: - CustomStringConvertible
extension Pitch: CustomStringConvertible {
    
    /// String representation of Pitch
    public var description: String {
        var result: String = "Pitch: \(midi.value)"
        if hasBeenSpelled { result += "; \(spelling!)" }
        return result
    }
}

public func ==(lhs: Pitch, rhs: Pitch) -> Bool {
    return lhs.midi.value == rhs.midi.value
}

public func <(lhs: Pitch, rhs: Pitch) -> Bool {
    return lhs.midi.value < rhs.midi.value
}

public func >(lhs: Pitch, rhs: Pitch) -> Bool {
    return lhs.midi.value > rhs.midi.value
}

public func <=(lhs: Pitch, rhs: Pitch) -> Bool {
    return lhs.midi.value <= rhs.midi.value
}

public func >=(lhs: Pitch, rhs: Pitch) -> Bool {
    return lhs.midi.value >= rhs.midi.value
}