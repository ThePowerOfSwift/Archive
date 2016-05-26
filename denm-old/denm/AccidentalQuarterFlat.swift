import UIKit
import QuartzCore

/**
AccidentalQuartetFlat
*/
class AccidentalQuarterFlat: Accidental {

    // MARK: Column Dimensions
    
    /// y-value of top of column
    var columnTopY: CGFloat = 0
    
    /// y-value of bottom of column
    var columnBottomY: CGFloat = 0
    
    // MARK: Bowl Dimensions
    
    /// Thickness of Bowl at top
    var bowlThicknessTop: CGFloat = 0
    
    /// Thickness of Bowl at bottom
    var bowlThicknessBottom: CGFloat = 0
    
    /// Thickness of Bowl at stress
    var bowlThicknessStress: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addComponents() {
        addColumnTop()
        addColumnBottom()
        addBody()
        addHole()
    }
    
    internal func addColumnTop() {
        let left: CGFloat = width - thinLineWidth
        let right: CGFloat = width
        let y: CGFloat = 0
        
        outlinePoints.extend([
            [[left, y]],
            [[right, y]]
        ])
    }
    
    internal func addColumnBottom() {
        let left: CGFloat = width - thinLineWidth
        let right: CGFloat = width
        let y: CGFloat = yRel + 0.618 * g // get this hardcoded shit out of here
        
        outlinePoints.extend([
            [[right, y]],
            [[left, y]]
        ])
    }
    
    internal func addBody() {
        let left: CGFloat = 0
        let right: CGFloat = width - thinLineWidth
        let y: CGFloat = yRel - 0.5 * g
        
        outlinePoints.extend([
            [
                [left, y],
                [right - 0.125 * g, yRel + 0.618 * g - 0.333 * g],
                [left - 0.25 * g, yRel - 0.5 * g + 0.25 * g]
            ],
            [
                [right, y],
                [left + 0.25 * g, yRel - 0.5 * g - 0.25 * g],
                [right, y]
            ]
        ])
    }
    
    internal func addHole() {
        let left: CGFloat = bowlThicknessStress
        let right: CGFloat = width - thinLineWidth
        let top: CGFloat = yRel - 0.5 * g + bowlThicknessTop
        let bottom: CGFloat = yRel + 0.618 * g - bowlThicknessBottom
        
        holePoints = [
            [
                // bottom right
                [right, bottom]
            ],
            [
                // top left
                [left, top],
                [right, bottom],
                [left - 0.125 * g, top + 0.125 * g]
            ],
            [
                // top right
                [right, top],
                [left + 0.125 * g, top - 0.125 * g],
                [right, top]
            ]
        ]
    }
    
    override func setWidth() {
        width = midWidth
        xRel = 0.5 * width
    }
    
    override func setHeight() {
        setBowlThickness()
        columnTopY = -1.618 * g
        columnBottomY = 0.618 * g
        yRel = -columnTopY
        height = -columnTopY + columnBottomY
    }
    
    internal func setBowlThickness() {
        bowlThicknessTop = 0.1236 * g
        bowlThicknessBottom = 0.25 * g
        bowlThicknessStress = 0.25 * g
    }
}