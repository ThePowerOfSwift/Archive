import UIKit
import QuartzCore

/**
AccidentalSharp
*/
class AccidentalSharp: Accidental {
    
    internal var leftColumnTopY: CGFloat = 0
    internal var leftColumnBottomY: CGFloat = 0
    internal var rightColumnTopY: CGFloat = 0
    internal var rightColumnBottomY: CGFloat = 0
    internal var thickLineΔY: CGFloat = 0
    
    override func addComponents() {
        addLeftColumnTop()
        addBodyTop()
        addRightColumnTop()
        addRightFlanks()
        addRightColumnBottom()
        addBodyBottom()
        addLeftColumnBottom()
        addLeftFlanks()
        addHole()
    }
    
    internal func addLeftColumnTop() {
        let left: CGFloat = flankWidth
        let right: CGFloat = flankWidth + thinLineWidth
        let y: CGFloat = yRel + leftColumnTopY
        
        outlinePoints.extend([
            [[left, y]],
            [[right, y]]
        ])
    }
    
    internal func addBodyTop() {
        let left: CGFloat = flankWidth + thinLineWidth
        let right: CGFloat = width - flankWidth - thinLineWidth
        
        outlinePoints.extend([
            [[left, getThickLineYAtX(left, ΔY: -thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: -thickLineΔY, dir: -1)]]
        ])
    }
    
    internal func addRightColumnTop() {
        let left: CGFloat = width - flankWidth - thinLineWidth
        let right: CGFloat = width - flankWidth
        let y: CGFloat = yRel + rightColumnTopY
        
        outlinePoints.extend([
            [[left, y]],
            [[right, y]]
        ])
    }
    
    internal func addRightFlanks() {
        let left: CGFloat = width - flankWidth
        let right: CGFloat = width
        
        outlinePoints.extend([
            [[left, getThickLineYAtX(left, ΔY: -thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: -thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: -thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: -thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: 1)]],
        ])
    }
    
    internal func addRightColumnBottom() {
        let left: CGFloat = width - flankWidth - thinLineWidth
        let right: CGFloat = width - flankWidth
        let y: CGFloat = yRel + rightColumnBottomY
        
        outlinePoints.extend([
            [[right, y]],
            [[left, y]]
        ])
    }
    
    internal func addBodyBottom() {
        let left: CGFloat = flankWidth + thinLineWidth
        let right: CGFloat = width - flankWidth - thinLineWidth
        
        outlinePoints.extend([
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: 1)]]
        ])
    }
    
    internal func addLeftColumnBottom() {
        let left: CGFloat = flankWidth
        let right: CGFloat = flankWidth + thinLineWidth
        let y: CGFloat = yRel + leftColumnBottomY
        
        outlinePoints.extend([
            [[right, y]],
            [[left, y]]
        ])
    }
    
    internal func addLeftFlanks() {
        let left: CGFloat = 0
        let right: CGFloat = flankWidth
        
        outlinePoints.extend([
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: -thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: -thickLineΔY, dir: 1)]],
            [[left, getThickLineYAtX(left, ΔY: -thickLineΔY, dir: -1)]],
            [[right, getThickLineYAtX(right, ΔY: -thickLineΔY, dir: -1)]]
        ])
    }
    
    internal func addHole() {
        let left: CGFloat = flankWidth + thinLineWidth
        let right: CGFloat = width - flankWidth - thinLineWidth
        
        holePoints = [
            [[left, getThickLineYAtX(left, ΔY: -thickLineΔY, dir: 1)]],
            [[right,getThickLineYAtX(right, ΔY: -thickLineΔY, dir: 1)]],
            [[right, getThickLineYAtX(right, ΔY: thickLineΔY, dir: -1)]],
            [[left, getThickLineYAtX(left, ΔY: thickLineΔY, dir: -1)]]
        ]
    }
    
    internal override func setWidth() {
        width = midWidth + 2 * flankWidth
        xRel = 0.5 * width
    }
    
    internal override func setHeight() {
        setThickLineΔY()
        leftColumnTopY = -0.95 * g
        leftColumnBottomY = 1.05 * g
        rightColumnTopY = -1.05 * g
        rightColumnBottomY = 0.95 * g
        yRel = -rightColumnTopY
        height = -rightColumnTopY + leftColumnBottomY
    }
    
    internal override func setThickLineΔY() {
         thickLineΔY = 0.4125 * g
    }
}