//
//  StaffRepresentablePitch.swift
//  Staff
//
//  Created by James Bean on 6/15/16.
//
//

import PitchSpellingTools

public struct StaffRepresentablePitch {
    
    /// `SpelledPitch` that can be represented on a staff.
    public let spelledPitch: SpelledPitch
    
    /// The type of notehead.
    public let noteheadKind: Notehead.Kind
    
    /// The type of accidental.
    public let accidentalKind: AccidentalKind
    
    /// Create a `StaffRepresentablePitch` with a `SpelledPitch` and `NoteheadKind`.
    public init(_ spelledPitch: SpelledPitch, _ noteheadKind: Notehead.Kind = .ord) {
        self.spelledPitch = spelledPitch
        self.noteheadKind = noteheadKind
        self.accidentalKind = AccidentalKind(spelling: spelledPitch.spelling)!
    }
}

extension StaffRepresentablePitch: Equatable {
    
    public static func == (lhs: StaffRepresentablePitch, rhs: StaffRepresentablePitch)
        -> Bool
    {
        return (
            lhs.spelledPitch == rhs.spelledPitch &&
            lhs.noteheadKind == rhs.noteheadKind &&
            lhs.accidentalKind == rhs.accidentalKind
        )
    }
}

extension StaffRepresentablePitch: Hashable {
    
    public var hashValue: Int {
        return spelledPitch.hashValue ^ noteheadKind.hashValue ^ accidentalKind.hashValue
    }
}

extension StaffRepresentablePitch: Comparable {
    
    public static func < (lhs: StaffRepresentablePitch, rhs: StaffRepresentablePitch) -> Bool {
        return lhs.spelledPitch < rhs.spelledPitch
    }
}
