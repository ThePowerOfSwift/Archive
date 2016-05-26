import UIKit
import QuartzCore

/**
StaffInfoLayer
*/
class StaffInfoLayer: GraphInfoLayer {
    
    // MARK: Components
    
    /// All noteheads on Staff
    var noteheads: [Notehead] = []
    
    /// All accidentals on Staff
    var accidentals: [Accidental] = []
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a StaffInfoLayer
    
    /**
    Add Notehead to StaffInfoLayer
    
    :param: notehead Notehead
    
    :returns: Self: StaffInfoLayer
    */
    func addNotehead(notehead: Notehead) -> StaffInfoLayer {
        noteheads.append(notehead)
        return self
    }
    
    /**
    Add Accidental to StaffInfoLayer
    
    :param: accidental Accidental
    
    :returns: Self: StaffInfoLayer
    */
    func addAccidental(accidental: Accidental) -> StaffInfoLayer {
        accidentals.append(accidental)
        return self
    }
    
    override func commitComponents() {
        commitNoteheads()
        commitAccidentals()
        commitArticulations()
        commitSlurs()
    }
    
    internal func commitNoteheads() {
        for notehead in noteheads { commitComponent(notehead) }
    }
    
    internal func commitAccidentals() {
        for accidental in accidentals { commitComponent(accidental) }
    }
    
    internal func commitSlurs() {
        //println("amount slurs: \(slurs.count)")
        for slur in slurs { commitComponent(slur) }
    }
}