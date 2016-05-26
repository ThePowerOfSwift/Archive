import QuartzCore

/**
Pitch
*/
class Pitch: Printable {
    
    var description: String { get { return "Pitch: \(midi); PitchClass: \(pitchClass)" } }
    
    /// PitchSpelling
    var spelling: PitchSpelling?
    
    /// MIDI representation of Pitch
    var midi: Float
    
    /// Pitch class of Pitch -- use PitchClass here?
    var pitchClass: Float { get { return midi % 12.0 } }
    
    /// If Pitch has been spelled
    var hasBeenSpelled: Bool { get { return spelling != nil } }
    
    /**
    Resolution of Pitch
    
    - 1.00: Natural, Flat, Sharp
    - 0.50: QuarterSharp, QuarterFlat
    - 0.25: NaturalUp, QuarterSharpDown, FlatUp, etc
    */
    var resolution: Float {
        get {
            if midi % 1 == 0 { return 1.0 }
            else if midi % 0.5 == 0 { return 0.5 }
            else { return 0.25 }
        }
    }
    
    /// Octave of Pitch
    var octave: Int {
        get {
            var octave = Int(floor(midi - 60.0)/12.0)
            if midi < 60 && midi % 12 != 0 { octave -= 1 }
            return octave
        }
    }
    
    /// Distance from MiddleC in Staff Spaces
    var staffSpacesFromMiddleC: CGFloat {
        get { return spelling!.staffSpacesFromMiddleC + CGFloat(octave) * 3.5 }
    }
    
    // MARK: Create a Pitch
    
    /**
    Create a Pitch with MIDI value
    
    :param: midi MIDI representation of Pitch
    
    :returns: Self: Pitch
    */
    init(midi: Float) {
        self.midi = midi
    }
    
    /**
    In the case of single pitch in StaffEvent, uses PitchSpelling with least "Sharpness"
    */
    func spell() {
        // only in the case of a single pitch: use first pitch spelling option
        let pitchSpellingsByPitchClass = PitchSpellingsByIntervalPitchClass.sharedInstance
        spelling = pitchSpellingsByPitchClass[pitchClass][0]
    }
}