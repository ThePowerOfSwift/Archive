
/**
PitchSpeller takes in pitches in the following formats:

- Single Pitch
- Array of Pitches (Verticality)
- Array of Array of Pitches (Diagonality)
*/
class PitchSpeller {
    
    let pitchSpellingsByIntervalPitchClass = PitchSpellingsByIntervalPitchClass.sharedInstance
    
    init(pitch: Pitch) {
        // return single PitchSpelling
    }
    
    init(verticality: [Pitch]) {
        // return array of PitchSpellings
    }
    
    init(diagonality: [[Pitch]]) {
        // return array of array of PitchSpellings
    }
}