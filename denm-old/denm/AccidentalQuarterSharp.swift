import UIKit
import QuartzCore

/**
AccidentalQuarterSharp
*/
class AccidentalQuarterSharp: Accidental {

    var columnTopY: CGFloat = 0
    var columnBottomY: CGFloat = 0
    var thickLineΔY: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addComponents() {
        addColumnTop()
        addRightFlank()
        addColumnBottom()
        addLeftFlank()
    }
    
    func addColumnTop() {
        let left: CGFloat = 0.5 * width - 0.5 * thinLineWidth
        let right: CGFloat = 0.5 * width + 0.5 * thinLineWidth
        let y: CGFloat = yRel + columnTopY
        
        outlinePoints.extend([
            [[left, y]],
            [[right, y]]
        ])
    }
    
    func addRightFlank() {
        let left: CGFloat = 0.5 * width + 0.5 * thinLineWidth
        let right: CGFloat = width
        
        outlinePoints.extend([
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: 1)]]
        ])
    }
    
    func addColumnBottom() {
        let left: CGFloat = 0.5 * width - 0.5 * thinLineWidth
        let right: CGFloat = 0.5 * width + 0.5 * thinLineWidth
        let y: CGFloat = yRel + columnBottomY
        
        outlinePoints.extend([
            [[right, y]],
            [[left, y]]
        ])
    }
    
    func addLeftFlank() {
        let left: CGFloat = 0
        let right: CGFloat = 0.5 * width - 0.5 * thinLineWidth
        
        outlinePoints.extend([
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: -1)]]
        ])
    }
    
    override func setWidth() {
        width = 1.236 * midWidth
        xRel = 0.5 * width
    }
    
    override func setHeight() {
        columnTopY = -1.236 * g // check these
        columnBottomY = 1.236 * g
        yRel = -columnTopY
        height = yRel + columnBottomY
    }
}