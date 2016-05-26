//
//  PitchSpelling.swift
//  DNMModel
//
//  Created by James Bean on 8/12/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

// TODO: wrap up middle-c neighborhood octave management

/**
Collection of attributes for visually representing a Pitch (accidental, pitchClass). With
1/8-th resolution.
*/
public struct PitchSpelling: Comparable {
    
    // MARK: - Attributes
    
    /// Pitch being spelled by PitchSpelling
    public var pitch: Pitch
    
    /**
    Coarse value of PitchSpelling (Natural, Sharp, Flat, QuarterSharp, QuarterFlat).
    Directly related to the "body" of the accidental. Provides 1/4-tone resolution.
    */
    public var coarse: PitchCoarseValue
    
    /**
    Fine value of PitchSpelling (Up, Down). Directly related to the "arrow" of the accidental.
    Provides 1/8-tone resolution.
    */
    public var fine: PitchFineValue
    
    /// PitchLetterName of PitchSpelling
    public var letterName: PitchLetterName
    
    /// Octave of PitchSpelling
    public var octave: Int
    
    // MARK: - Analyze a PitchSpelling
    
    /** Resolution of a PitchSpelling.
    (Chromatic (Natural, Sharp, Flat) = 1 , 1/4-tone (QuarterSharp, QuarterFlat) = 0.5,
    1/8-tone (Natural_up, QuartFlat_down, etc.) = 0.25)
    */
    public var resolution: Float {
        get { return fineResolution != 0.0 ? 0.25 : coarseResolution == 1 ? 1 : 0.5 }
    }
    
    /// Resolution of coarse value of PitchSpelling (Chromatic = 1, 1/4-tone = 0.5)
    public var coarseResolution: Float { get { return coarse % 1 == 0 ? 1 : 0.5 } }
    
    /// Resolution of fine value of PitchSpelling (Chromatic / 1/4-tone = 0, 1.8th-tone = 0.25)
    public var fineResolution: Float { get { return fine == 0.0 ? 0 : 0.25 } }
    
    /// Direction of coarse value of PitchSpelling (Sharp side = 1, Natural = 0, Flat side = -1)
    public var coarseDirection: Float { get { return coarse == 0.0 ? 0 : coarse < 0 ? -1 : 1 } }
    
    /// Direction of fine value of PitchSpelling (Up = 1, Down = -1)
    public var fineDirection: Float { get { return fine == 0.0 ? 0 : fine < 0 ? -1 : 1 } }
    
    /// Distance from c on circle of fifths. Negative numbers are flat, positive are sharp
    public var sharpness: Int {
        get { return getSharpnessWithLetterName(letterName, coarse: coarse)! }
    }
    
    private static var sharpnessByLetterNameAndCoarse: [(PitchLetterName, Float)] = [
        (.F, -1.0), // f flat
        (.C, -1.0), // c flat
        (.G, -1.0), // g flat
        (.D, -1.0), // d flat
        (.A, -1.0), // a flat
        (.E, -1.0), // e flat
        (.B, -1.0), // b flat
        (.F, +1.0), // f sharp
        (.C, +1.0), // c sharp
        (.G, +1.0), // g sharp
        (.D, +1.0), // d sharp
        (.A, +1.0), // a sharp
        (.E, +1.0), // e sharp
        (.B, +1.0)  // b sharp
    ]
    
    private class PitchSpellingsByPitchClass {
        class var sharedInstance: JSON {
            struct Static {
                static let instance: JSON = Static.getInstance()
                static func getInstance() -> JSON {
                    let bundle = NSBundle(forClass: PitchSpellingsByPitchClass.self)
                    let filePath = bundle.pathForResource("PitchSpellingsByPitchClass",
                        ofType: "json"
                    )!
                    let jsonData = NSData(contentsOfFile: filePath)!
                    let jsonObj: JSON = JSON(data: jsonData)
                    return jsonObj
                }
            }
            return Static.instance
        }
    }
    
    /// Returns all possible PitchSpellings for a given Pitch
    public static func pitchSpellingsForPitch(pitch pitch: Pitch) -> [PitchSpelling] {

        let midiValueAsString: String = pitch.pitchClass.midi.value.format("0.2")
        let pitchSpellings_json = PitchSpellingsByPitchClass.sharedInstance[midiValueAsString]
        
        var pitchSpellings: [PitchSpelling] = []
        for (_, pitchSpelling_json) in pitchSpellings_json {
            let coarse = pitchSpelling_json["coarse"].floatValue
            let fine = pitchSpelling_json["fine"].floatValue
            let letterName_string = pitchSpelling_json["letterName"].stringValue
            let letterName = PitchLetterName.pitchLetterNameWithString(
                string: letterName_string
            )!

            // wrap up: compensate for middle-c awkwardness
            var octave: Int = pitch.octave
            if letterName == .C && coarse == 0 && fine == -0.25 { octave += 1 }
            if letterName == .C && coarse == -0.5 { octave += 1 }

            // create PitchSpelling
            let pitchSpelling = PitchSpelling(
                pitch: pitch,
                coarse: coarse,
                fine: fine,
                letterName: letterName,
                octave: octave
            )
            
            pitchSpellings.append(pitchSpelling)
        }
        return pitchSpellings
    }
    
    /**
    Create a PitchSpelling with attributes.
    
    - parameter coarse:         Natural, Sharp, Flat, QuarterSharp, QuarterFlat
    - parameter fine:           _up, _down, no arrow
    - parameter staffPlacement: Amount of staff spaces from C below pitch.
    
    - returns: Initialized PitchSpelling object
    */
    public init(
        pitch: Pitch,
        coarse: Float,
        fine: Float,
        letterName: PitchLetterName,
        octave: Int = 0
    )
    {
        self.pitch = pitch
        self.coarse = coarse
        self.fine = fine
        self.letterName = letterName
        self.octave = octave
    }
    
    private func getSharpnessWithLetterName(letterName: PitchLetterName, coarse: Float) -> Int? {
        if coarse == 0.0 { return 0 }
        let coarse_quantized = coarse < 0.0 ? floor(coarse) : ceil(coarse)
        let tuple: (PitchLetterName, Float) = (letterName, coarse_quantized)
        for (index, el) in PitchSpelling.sharpnessByLetterNameAndCoarse.enumerate() {
            if el.0 == tuple.0 && el.1 == tuple.1 {
                var sharpness = index - PitchSpelling.sharpnessByLetterNameAndCoarse.count / 2
                if sharpness >= 0 { sharpness += 1 }
                return sharpness
            }
        }
        return nil
    }
}

// MARK: - CustomStringConvertible
extension PitchSpelling: CustomStringConvertible {
    
    /// String representation of PitchSpelling
    public var description: String {
        let coarseName = getCoarseNameByCoarse(coarse)
        let fineName = getFineNameByFine(fine)
        var result: String = "\(letterName)_\(coarseName)"
        if fine != 0.0 { result += "_\(fineName)" }
        return result
    }
    
    private func getFineNameByFine(fine: Float) -> String {
        let fineNameByFine: [Float : String] = [ -0.25: "DOWN", +0.00: "",  +0.25: "UP" ]
        return fineNameByFine[fine]!
    }
    
    private func getCoarseNameByCoarse(coarse: Float) -> String {
        let coarseNameByCoarse: [Float : String] = [
            -1.0: "FLAT",
            -0.5: "1/4_FLAT",
            +0.0: "NATURAL",
            +0.5: "1/4_SHARP",
            +1.0: "SHARP"
        ]
        return coarseNameByCoarse[coarse]!
    }
}

public func == (lhs: PitchSpelling, rhs: PitchSpelling) -> Bool {
    return (
        lhs.coarse == rhs.coarse &&
            lhs.fine == rhs.fine &&
            lhs.letterName == rhs.letterName
    )
}

public func < (lhs: PitchSpelling, rhs: PitchSpelling) -> Bool {
    if lhs.octave == rhs.octave {
        if lhs.letterName == rhs.letterName {
            if lhs.coarse == rhs.coarse { return lhs.fine < rhs.fine  }
            else { return lhs.coarse < rhs.coarse }
        }
        else { return lhs.letterName < rhs.letterName }
    }
    else { return lhs.octave < rhs.octave }
}

public func > (lhs: PitchSpelling, rhs: PitchSpelling) -> Bool {
    if lhs.octave == rhs.octave {
        if lhs.letterName == rhs.letterName {
            if lhs.coarse == rhs.coarse { return lhs.fine > rhs.fine  }
            else { return lhs.coarse > rhs.coarse }
        }
        else { return lhs.letterName > rhs.letterName }
    }
    else { return lhs.octave > rhs.octave }
}

public func >= (lhs: PitchSpelling, rhs: PitchSpelling) -> Bool {
    if lhs.octave == rhs.octave {
        if lhs.letterName == rhs.letterName {
            if lhs.coarse == rhs.coarse { return lhs.fine >= rhs.fine  }
            else { return lhs.coarse >= rhs.coarse }
        }
        else { return lhs.letterName >= rhs.letterName }
    }
    else { return lhs.octave >= rhs.octave }
}

public func <= (lhs: PitchSpelling, rhs: PitchSpelling) -> Bool {
    if lhs.octave == rhs.octave {
        if lhs.letterName == rhs.letterName {
            if lhs.coarse == rhs.coarse { return lhs.fine <= rhs.fine  }
            else { return lhs.coarse <= rhs.coarse }
        }
        else { return lhs.letterName <= rhs.letterName }
    }
    else { return lhs.octave <= rhs.octave }
}
