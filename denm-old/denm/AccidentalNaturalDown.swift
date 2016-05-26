import UIKit
import QuartzCore

/**
AccidentalNaturalDown
*/
class AccidentalNaturalDown: AccidentalNatural {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addRightColumnBottom()  {
        addArrow(width - 0.5 * thinLineWidth, y: height, dir: -1)
    }
    
    override func setHeight() {
        setThickLineΔY()
        leftColumnTopY = -1.236 * g
        rightColumnBottomY = 2 * g
        yRel = -leftColumnTopY
        height = yRel + rightColumnBottomY
    }
}