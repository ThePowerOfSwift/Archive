//
//  PitchDyad.swift
//  DNMModel
//
//  Created by James Bean on 8/12/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
Pair of Pitches
*/
public class PitchDyad: CustomStringConvertible {
    
    // MARK: String Representation
    public var description: String { get { return getDescription() } }
    
    // MARK: Pitches
    
    /// Lower of two pitches
    public var pitch0: Pitch
    
    /// Higher of two pitches
    public var pitch1: Pitch
    
    // MARK: Analyze a PitchDyad
    public var interval: PitchInterval { get {
        return PitchInterval(midi: pitch1.midi - pitch0.midi) }
    }
    
    /// All possible PitchSpellings for PitchDyad
    public var pitchSpellings: [PitchSpelling] { get { return [] } }
    
    /**
    Create a PitchDyad with two Pitches
    
    - parameter pitch0: Pitch
    - parameter pitch1: Pitch
    
    - returns: Initialized PitchDyad
    */
    public init(pitch0: Pitch, pitch1: Pitch) {
        
        // ensure pitch0 is lower
        self.pitch0 = [pitch0, pitch1].sort(<).first!
        
        // ensure pitch1 is higher
        self.pitch1 = [pitch0, pitch1].sort(>).first!
    }
    
    public func clearPitchSpellings() {
        for pitch in [pitch0, pitch1] { pitch.clearPitchSpelling() }
    }
    
    public func getDescription() -> String {
        return "[\(pitch0), \(pitch1)]"
    }
}