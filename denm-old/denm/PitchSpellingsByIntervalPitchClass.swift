import QuartzCore

class PitchSpellingsByIntervalPitchClass {
    
    var pitchSpellingsByIntervalPitchClass = Dictionary<Float, [PitchSpelling]>()
    
    init() { addPitchSpellings() }
    
    class var sharedInstance: PitchSpellingsByIntervalPitchClass {
        struct Singleton { static let instance = PitchSpellingsByIntervalPitchClass() }
        return Singleton.instance
    }
    
    subscript(pitchClass: Float) -> [PitchSpelling] {
        return pitchSpellingsByIntervalPitchClass[pitchClass]!
    }

    func addPitchSpellings() {
        // C natural
        pitchSpellingsByIntervalPitchClass[00.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.0, coarse: +0.00, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[00.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.0, coarse: +0.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 0.0, coarse: +0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[00.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.0, coarse: +0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[00.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.0, coarse: +0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 0.0, coarse: +1.0, fine: -0.25),
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: -1.0, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[01.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.0, coarse: +1.0, fine: +0.00),
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: -1.0, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[01.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.0, coarse: +1.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: -1.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: -0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[01.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: -0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[01.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: -0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: +0.0, fine: -0.25)
        ]
        // D natural
        pitchSpellingsByIntervalPitchClass[02.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: +0.0, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[02.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: +0.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: +0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[02.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: +0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[02.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: +0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: +1.0, fine: -0.25),
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: -1.0, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[03.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: +1.0, fine: +0.00),
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: -1.0, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[03.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 0.5, coarse: +1.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: -1.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: -0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[03.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: -0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[03.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: -0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: -0.0, fine: -0.25)
        ]
        // E natural
        pitchSpellingsByIntervalPitchClass[04.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: +0.0, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[04.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: +0.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: +0.5, fine: -0.25),
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: -0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[04.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: +0.5, fine: +0.00),
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: -0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[04.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.0, coarse: +0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: -0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: +0.0, fine: -0.25)
        ]
        // F natural
        pitchSpellingsByIntervalPitchClass[05.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: +0.0, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[05.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: +0.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: +0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[05.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: +0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[05.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: +0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: +1.0, fine: -0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: -1.0, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[06.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: +1.0, fine: +0.00),
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: -1.0, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[06.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 1.5, coarse: +1.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: -1.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: -0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[06.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: -0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[06.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: -0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: +0.0, fine: -0.25)
        ]
        // G natural
        pitchSpellingsByIntervalPitchClass[07.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: +0.0, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[07.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: +0.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: +0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[07.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: +0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[07.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: +0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: +1.0, fine: -0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: -1.0, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[08.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: +1.0, fine: +0.00),
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: -1.0, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[08.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.0, coarse: +1.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: -1.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: -0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[08.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: -0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[08.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: -0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: +0.0, fine: -0.25)
        ]
        // A natural
        pitchSpellingsByIntervalPitchClass[09.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: +0.0, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[09.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: +0.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: +0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[09.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: +0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[09.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: +0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: +1.0, fine: -0.25),
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: -1.0, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[10.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: +1.0, fine: +0.00),
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: -1.0, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[10.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 2.5, coarse: +1.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: -1.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: -0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[10.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: -0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[10.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: -0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: +0.0, fine: -0.25)
        ]
        // B natural
        pitchSpellingsByIntervalPitchClass[11.00] = [
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: +0.0, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[11.25] = [
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: +0.0, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: +0.5, fine: -0.25),
            PitchSpelling(staffSpacesFromMiddleC: 3.5, coarse: -0.5, fine: -0.25)
        ]
        pitchSpellingsByIntervalPitchClass[11.50] = [
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: +0.5, fine: +0.00),
            PitchSpelling(staffSpacesFromMiddleC: 3.5, coarse: -0.5, fine: +0.00)
        ]
        pitchSpellingsByIntervalPitchClass[11.75] = [
            PitchSpelling(staffSpacesFromMiddleC: 3.0, coarse: +0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 3.5, coarse: -0.5, fine: +0.25),
            PitchSpelling(staffSpacesFromMiddleC: 3.5, coarse: +0.0, fine: -0.25)
        ]
    }
}