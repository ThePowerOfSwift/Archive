//
//  PitchClass.swift
//  DNMModel
//
//  Created by James Bean on 1/9/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public struct PitchClass {
    
    /// MIDI representation of Pitch (middle-c = 60.0, C5 = 72.0, C3 = 48.0, etc)
    public var midi: MIDI
    
    /// Frequency representation of Pitch (middle-c = 261.6)
    public var frequency: Frequency
    
    public init(midi: MIDI) {
        self.midi = midi
        self.frequency = Frequency(midi: midi)
    }
    
    public init(frequency: Frequency) {
        self.frequency = frequency
        self.midi = MIDI(frequency: frequency)
    }
}