import UIKit
import QuartzCore

/**
AccidentalFlatDown
*/
class AccidentalFlatDown: AccidentalFlat {
    
    internal override func addColumnBottom() {
        let y: CGFloat = yRel + 0.618 * g
        outlinePoints.extend([
            [
                [thinLineWidth, y],
                [width + 0.25 * g, yRel - 0.5 * g + 0.25 * g],
                [thinLineWidth + 0.125 * g, y - 0.333 * g]
            ]
        ])
        addArrow(0.5 * thinLineWidth, y: height, dir: -1)
    }
    
    internal override func setHeight() {
        setBowlThickness()
        columnTopY = -1.618 * g
        columnBottomY = 1.75 * g
        yRel = -columnTopY
        height = -columnTopY + columnBottomY
    }
}