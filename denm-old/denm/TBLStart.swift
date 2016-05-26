import QuartzCore
import UIKit

/**
TBLStart (Tuplet Bracket Ligature Start)
*/
class TBLStart: TBLigature {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addComponents() {
        addLine()
        addBeamEndArrow()
    }
    
    func addBeamEndArrow() {
        let arrow: TBLOArrow = TBLOArrow()!
            .setSize(g: g)
            .setX(0)
            .setTipY(frame.height)
            .setOrientation(-1)
            .build()
        addSublayer(arrow)
        beamEndOrnament = arrow
    }
}