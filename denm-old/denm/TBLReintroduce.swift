import QuartzCore
import UIKit

/**
TBLReintroduce (Tuplet Bracket Ligature Reintroduce)
*/
class TBLReintroduce: TBLigature {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addComponents() {
        addLine()
        line.lineDashPattern = [0.236 * g]
        addBracketEndCircle()
        addBeamEndArrow()
    }
    
    internal func addBeamEndArrow() {
        let arrow: TBLOArrow = TBLOArrow()!
            .setSize(g: g)
            .setX(0)
            .setTipY(frame.height)
            .setOrientation(-1)
            .build()
        addSublayer(arrow)
        beamEndOrnament = arrow
    }
    
    internal func addBracketEndCircle() {
        let circle: TBLOCircle = TBLOCircle()!
            .setSize(g: g)
            .setX(0)
            .setY(0)
            .build()
        addSublayer(circle)
        bracketEndOrnament = circle
    }
}