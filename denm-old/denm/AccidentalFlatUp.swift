import UIKit
import QuartzCore

/**
AccidentalFlatUp
*/
class AccidentalFlatUp: AccidentalFlat {

    internal override func addColumnTop() {
        addArrow(0.5 * thinLineWidth, y: 0, dir: 1)
    }
    
    internal override func setHeight() {
        setBowlThickness()
        columnTopY = -2.236 * g
        columnBottomY = 0.618 * g
        yRel = -columnTopY
        height = -columnTopY + columnBottomY
    }
}