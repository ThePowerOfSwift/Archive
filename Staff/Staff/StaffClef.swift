//
//  StaffClef.swift
//  Staff
//
//  Created by James Bean on 1/11/17.
//
//

import PitchSpellingTools
import Plot

public struct StaffClef: Plot.Axis {
    
    public enum Kind: Int {
        case bass = 6
        case tenor = 2
        case alto = 0
        case treble = -6
    }

    public let kind: Kind
    public let coordinate: (SpelledPitch) -> StaffSlot
    
    public init(_ kind: Kind) {
        self.kind = kind
        self.coordinate = { spelledPitch in slot(spelledPitch, kind) }
    }
}

internal let slot: (SpelledPitch, StaffClef.Kind) -> StaffSlot = { spelledPitch, clef in
    let slotsPerOctave = 7
    let normalizedOctave = 5 - spelledPitch.octave
    let octaveDisplacement = slotsPerOctave * normalizedOctave
    let steps = spelledPitch.spelling.letterName.steps
    let middleCSlot = clef.rawValue
    return middleCSlot - octaveDisplacement + steps
}
