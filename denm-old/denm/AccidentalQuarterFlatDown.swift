import UIKit
import QuartzCore

/**
AccidentalQuarterFlatDown
*/
class AccidentalQuarterFlatDown: AccidentalQuarterFlat {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addColumnBottom() {
        addArrow(width - 0.5 * thinLineWidth, y: height, dir: -1)
        
        let y: CGFloat = yRel + 0.618 * g
        outlinePoints.extend([
            [[width - thinLineWidth, y]]
        ])
    }
    
    override func setHeight() {
        setBowlThickness()
        columnTopY = -1.618 * g
        columnBottomY = 1.75 * g
        yRel = -columnTopY
        height = -columnTopY + columnBottomY
    }
}