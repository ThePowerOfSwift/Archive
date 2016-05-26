import UIKit
import QuartzCore

/**
AccidentalNaturalUp
*/
class AccidentalNaturalUp: AccidentalNatural {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addLeftColumnTop() {
        addArrow(0.5 * thinLineWidth, y: 0, dir: 1)
    }
    
    override func setHeight() {
        setThickLineΔY()
        leftColumnTopY = -2 * g
        rightColumnBottomY = 1.236 * g
        yRel = -leftColumnTopY
        height = yRel + rightColumnBottomY
    }
}