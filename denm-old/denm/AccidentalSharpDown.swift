import UIKit
import QuartzCore

/**
AccidentalSharpDown
*/
class AccidentalSharpDown: AccidentalSharp {
    
    override func addRightColumnBottom() {
        addArrow(width - flankWidth - 0.5 * thinLineWidth, y: height, dir: -1)
    }
    
    override func setHeight() {
        setThickLineΔY()
        leftColumnTopY = -0.95 * g
        leftColumnBottomY = 1.05 * g
        rightColumnTopY = -1.05 * g
        rightColumnBottomY = 2 * g
        yRel = -rightColumnTopY
        height = -rightColumnTopY + rightColumnBottomY
0    }
}