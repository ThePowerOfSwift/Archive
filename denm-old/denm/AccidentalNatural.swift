import UIKit
import QuartzCore

/**
AccidentalNatural
*/
class AccidentalNatural: Accidental {

    // MARK: Column Dimensions
    var leftColumnTopY: CGFloat = 0
    var rightColumnBottomY: CGFloat = 0
    
    // MARK: Thick Line Dimensions
    
    /// Distance of thickLine from vertical center of Accidental
    var thickLineΔY: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    internal override func addComponents() {
        addLeftColumnTop()
        addBodyTop()
        addRightColumnBottom()
        addBodyBottom()
        addHole()
    }
    
    internal func addLeftColumnTop() {
        let left: CGFloat = 0
        let right: CGFloat = thinLineWidth
        let y: CGFloat = yRel + leftColumnTopY
        
        outlinePoints.extend([
            [[left, y]],
            [[right, y]]
        ])
    }
    
    internal func addBodyTop() {
        let left: CGFloat = thinLineWidth
        let right: CGFloat = width
        
        outlinePoints.extend([
            [[left, getThickLineYAtX(left, ΔY: -thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: -thickLineΔY, dir: -1)]]
        ])
    }
    
    internal func addRightColumnBottom() {
        let left: CGFloat = width - thinLineWidth
        let right: CGFloat = width
        let y: CGFloat = yRel + rightColumnBottomY
        
        outlinePoints.extend([
            [[right, y]],
            [[left, y]]
        ])
    }
    
    internal func addBodyBottom() {
        let left: CGFloat = 0
        let right: CGFloat = width - thinLineWidth
        
        outlinePoints.extend([
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: 1)]]
        ])
    }
    
    internal func addHole() {
        let left: CGFloat = thinLineWidth
        let right: CGFloat = width - thinLineWidth
        
        holePoints = [
            [[left, getThickLineYAtX(left, ΔY: -thickLineΔY, dir: 1)]],
            [[right, getThickLineYAtX(right, ΔY: -thickLineΔY, dir: 1)]],
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: -1)]],
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: -1)]]
        ]
    }

    override func setWidth() {
        width = midWidth
        xRel = 0.5 * width
    }
    
    override func setHeight() {
        leftColumnTopY = -1.236 * g
        rightColumnBottomY = 1.236 * g
        thickLineΔY = 0.4125 * g
        yRel = -leftColumnTopY
        height = yRel + rightColumnBottomY
    }
    
    override func setThickLineΔY() {
        thickLineΔY = 0.4125 * g
    }
}