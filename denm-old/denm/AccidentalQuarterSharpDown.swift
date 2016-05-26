import UIKit
import QuartzCore

/**
AccidentaQuarterSharpDown
*/
class AccidentalQuarterSharpDown: AccidentalQuarterSharp {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }

    override func addColumnBottom() {
        addArrow(0.5 * width, y: height, dir: -1)
    }
    
    override func setHeight() {
        columnTopY = -1.236 * g // check these
        columnBottomY = 2 * g
        yRel = -columnTopY
        height = yRel + columnBottomY
    }
}