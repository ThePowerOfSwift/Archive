import UIKit
import QuartzCore

/**
AccidentalFlat
*/
class AccidentalFlat: Accidental {
    
    // MARK: Column Dimensions
    
    /// y-value of top of column
    var columnTopY: CGFloat = 0
    
    /// y-value of bottom of column
    var columnBottomY: CGFloat = 0
    
    //MARK: Bowl Dimensions
    
    /// Thickness of bowl at top
    var bowlThicknessTop: CGFloat = 0
    
    /// Thickness of bowl at bottom
    var bowlThicknessBottom: CGFloat = 0
    
    /// Thickness of bowl at stress
    var bowlThicknessStress: CGFloat = 0
    
    internal override func addComponents() {
        addColumnTop()
        addBody()
        addColumnBottom()
        addHole()
    }
    
    internal func addColumnTop() {
        let left: CGFloat = 0
        let right: CGFloat = thinLineWidth
        let y: CGFloat = 0
        
        outlinePoints.extend([
            [[left, y]],
            [[right, y]]
        ])
    }
    
    internal func addBody() {
        let left: CGFloat = thinLineWidth
        let right: CGFloat = width
        let y: CGFloat = yRel - 0.5 * g
        
        outlinePoints.extend([
            [[left, y]],
            [
                [right, y],
                [left, y],
                [right - 0.125 * g, y - 0.125 * g]
            ]
        ])
    }
    
    internal func addColumnBottom() {
        let left: CGFloat = 0
        let right: CGFloat = thinLineWidth
        let y: CGFloat = height
        
        outlinePoints.extend([
            [
                [right, y],
                [width + 0.25 * g, yRel - 0.5 * g + 0.25 * g],
                [right + 0.125 * g, y - 0.333 * g]
            ],
            [[left, y]]
        ])
    }
    
    internal func addHole() {
        let left: CGFloat = thinLineWidth
        let right: CGFloat = width - bowlThicknessStress
        let top: CGFloat = yRel - 0.5 * g + bowlThicknessTop
        let bottom: CGFloat = yRel + 0.618 * g - bowlThicknessBottom // hard coded !
        
        holePoints = [
            [[left, top]],
            [
                [right, top],
                [left, top],
                [right - 0.125 * g, top - 0.125 * g]
            ],
            [
                [left, bottom],
                [right + 0.125 * g, top + 0.125 * g],
                [left, bottom]
            ]
        ]
    }
    
    internal override func setWidth() {
        width = midWidth
        xRel = 0.5 * width
    }
    
    internal override func setHeight() {
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