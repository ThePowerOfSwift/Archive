import UIKit
import QuartzCore

/**
TBCompoundStratum: Tuplet Bracket Compound Stratum
*/
class TBCompoundStratum: Stratum {

    // MARK: Components
    
    /// Reference to TBStratum in TBCompoundStratum
    var tbStrata: [TBStratum] = []
    
    // MARK: Incrementally build a TBCompoundStratum
    
    /**
    Add TBStratum (Tuplet Bracket Stratum)
    
    :param: tbStratum TBStratum
    
    :returns: Self: TBCompoundStratum
    */
    func addTBStratum(tbStratum: TBStratum) -> TBCompoundStratum {
        tbStrata.append(tbStratum)
        return self
    }
    
    override func setFrame() {
        height = tbStrata[0].height
        frame = CGRectMake(left, top, width, height)
    }
    
    override func setExternalPads() {
        externalPads.setBottom(tbStrata[0].externalPads.getBottom())
    }
    
    func highlight() {
        for tbStratum in tbStrata {
            tbStratum.hightlight()
        }
    }
}