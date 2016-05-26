import UIKit
import QuartzCore

/**
Dynamic Marking Interpolation: Hairpin Linear
*/
class DMIHairpinLinear: DMIHairpin {
    
    // MARK: Create a DMIHairpinLinear
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(layer: AnyObject) { super.init(layer: layer) }
    override init() { super.init() }
    
    override func addComponents() -> DMInterpolation {
        setPoints()
        addHairpin()
        return self
    }
    
    override func addHairpin() {
        let hairpin: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        
        // add first point
        path.moveToPoint(points[0])
        
        // add rest of the points
        for point in 1..<points.count { path.addLineToPoint(points[point]) }
        
        hairpin.path = path.CGPath
        hairpin.lineJoin = kCALineJoinBevel
        setVisualAttributes(hairpin)
        addSublayer(hairpin)
    }

    override func cresc() -> DMIHairpin {
        points = [
            CGPointMake(width, 0),
            CGPointMake(0, 0.5 * height),
            CGPointMake(width, height)
        ]
        return self
    }
    
    override func decresc() -> DMIHairpin {
        points = [
            CGPointMake(0, 0),
            CGPointMake(width, 0.5 * height),
            CGPointMake(0, height)
        ]
        return self
    }
}