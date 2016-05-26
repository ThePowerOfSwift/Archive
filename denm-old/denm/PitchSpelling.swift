import UIKit
import QuartzCore

/**
PitchSpelling
*/
class PitchSpelling {
    
    // MARK: Attributes
    
    /// Distance from middleC in staff spaces
    var staffSpacesFromMiddleC: CGFloat
    
    /// Coarse value of PitchSpelling (Sharp, Flat, QuarterSharp, etc.)
    var coarse: Float
    
    /// Fine value of PitchSpelling (up / down 1/8th tone)
    var fine: Float
    
    /// Coarse Direction of PitchSpelling (Sharp == QuarterSharp)
    var coarseDirection: Int {
        get { if coarse > 0 { return 1 }; if coarse < 0 { return -1 }; return 0 }
    }
    
    /// Fine Diration of PitchSpelling (NaturalUp == FlatUp)
    var fineDirection: Int {
        get { if fine > 0 { return 1 }; if fine < 0 { return -1 }; return 0 }
    }
    
    /// Coarse Resolution of PitchSpelling (Sharp == Flat)s
    var coarseResolution: Float { get { if coarse % 1 == 0 { return 1 }; return 0.5 } }
    
    /// Distance from middleC on circle-of-fifths
    var sharpness: Int { get { return getSharpness() } }
    
    // MARK: Create a PitchSpelling
    
    /**
    Create a PitchSpelling with staffSpacesFromMiddleC, coarse value and fine value
    
    :param: staffSpacesFromMiddleC Distance of PitchSpelling from middleC in staff spaces
    :param: coarse                 Coarse value of PitchSpelling
    :param: fine                   Fine value of PitchSpelling
    
    :returns: Self: PitchSpelling
    */
    init(staffSpacesFromMiddleC: CGFloat, coarse: Float, fine: Float) {
        self.staffSpacesFromMiddleC = staffSpacesFromMiddleC
        self.coarse = coarse
        self.fine = fine
    }
    
    
    private func getSharpness() -> Int {
        
        // 1.5 0   2   0.5 2.5 1   3                    // 1.5 0   2   0.5 2.5 1   3
        // Fb  Cb  Gb  Db  Ab  Eb  Bb // F C G D A E B  // F#  C#  G#  D#  A#  E#  B#
        // -7  -6  -5  -4  -3  -2  -1 // -------------- // +1  +2  +3  +4  +5  +6  +7
        
        let staffSpacesAndCoarseBySharpness: [(Int, Float, Float)] = [
            (-5, 2.0, -1.0), // g flat
            (-4, 0.5, -1.0), // d flat
            (-3, 2.5, -1.0), // a flat
            (-2, 1.0, -1.0), // e flat
            (-1, 3.0, -1.0), // b flat
            (+1, 1.5, +1.0), // f sharp
            (+2, 0.0, +1.0), // c sharp
            (+3, 2.0, +1.0), // g sharp
            (+4, 0.5, +1.0), // d sharp
            (+5, 2.5, +1.0)  // a sharp
        ]
        if coarse == 0 { return 0 }
        else {
            for (sh, s, c) in staffSpacesAndCoarseBySharpness {
                if s == Float(staffSpacesFromMiddleC) && c == coarse { return sh }
            }
            return 100
        }
    }
}

// create == function