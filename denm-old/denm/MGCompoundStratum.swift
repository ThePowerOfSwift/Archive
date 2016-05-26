import UIKit
import QuartzCore

/**
MGCompoundStratum (Metronome Graphic Compound Stratum)
*/
class MGCompoundStratum: Stratum {

    // MARK: View Context
    
    /// MGStratum (Metronome Graphic Stratum) in MGCompoundStratum
    var mgStrata: [MGStratum] = []
    
    // MARK: Attributes
    
    /// If MGCompoundStratum is included in View Context
    var isIncluded: Bool = false
    
    // MARK: Incrementally build a MGCompoundStratum
    
    /**
    Add MGStratum (Metrome Graphic Stratum) to MGCompoundStratum
    
    :param: mgStratum MGStratum
    
    :returns: Self: MGCompoundStratum
    */
    func addMGStratum(mgStratum: MGStratum) -> MGCompoundStratum {
        mgStrata.append(mgStratum)
        return self
    }
    
    /**
    Switch whether MGCompoundStratum is included in View Context
    */
    func switchIncludedState() {
        if isIncluded { exclude() }
        else { include() }
    }
    
    /**
    Set dimensions of MGCompoundStratum
    
    :returns: MGCompoundStratum
    */
    func build() -> MGCompoundStratum {
        setFrame()
        setHeightOfMGStrataToMaxHeight()
        return self
    }
    
    internal func include() {
        for mgStratum in mgStrata { mgStratum.include() }
        isIncluded = true
    }
    
    internal func exclude() {
        for mgStratum in mgStrata { mgStratum.exclude() }
        isIncluded = false
    }
    
    internal func setHeightOfMGStrataToMaxHeight() {
        for mgStratum in mgStrata { mgStratum.setHeight(height).setFrame() }
    }
    
    override func setFrame() {
        setExternalPads()
        height = getGreatestMGStratumHeight()
        frame = CGRectMake(left, top, width, height)
    }
    
    override func setExternalPads() {
        //externalPads.setBottom(10)
    }
    
    internal func getGreatestMGStratumHeight() -> CGFloat {
        var maxHeight: CGFloat = 0
        for mgStratum in mgStrata {
            maxHeight = mgStratum.frame.height > maxHeight ? mgStratum.frame.height : maxHeight
        }
        return maxHeight
    }
}