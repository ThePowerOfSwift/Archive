import UIKit
import QuartzCore

/**
AccidentalQuarterFlatUp
*/
class AccidentalQuarterFlatUp: AccidentalQuarterFlat {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addColumnTop() {
        addArrow(width - 0.5 * thinLineWidth, y: 0, dir: 1)
    }
    
    override func setHeight() {
        setBowlThickness()
        columnTopY = -2.236 * g
        columnBottomY = 0.618 * g
        yRel = -columnTopY
        height = -columnTopY + columnBottomY
    }
}