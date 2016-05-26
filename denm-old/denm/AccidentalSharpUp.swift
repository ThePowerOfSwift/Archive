import UIKit
import QuartzCore

/**
AccidentalSharpUp
*/
class AccidentalSharpUp: AccidentalSharp {

    override func addRightColumnTop() {
        addArrow(width - flankWidth - 0.5 * thinLineWidth, y: 0, dir: 1)
    }
    
    override func setHeight() {
        setThickLineΔY()
        leftColumnTopY = -0.95 * g
        leftColumnBottomY = 1.05 * g
        rightColumnTopY = -2 * g
        rightColumnBottomY = 0.95 * g
        yRel = -rightColumnTopY
        height = -rightColumnTopY + leftColumnBottomY
    }
}