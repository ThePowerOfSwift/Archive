import UIKit
import QuartzCore

/**
AccidentalQuarterSharpUp
*/
class AccidentalQuarterSharpUp: AccidentalQuarterSharp {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addColumnTop() {
        addArrow(0.5 * width, y: 0, dir: 1)
    }
    
    override func setHeight() {
        columnTopY = -2 * g // check these
        columnBottomY = 1.236 * g
        yRel = -columnTopY
        height = yRel + columnBottomY
    }
}