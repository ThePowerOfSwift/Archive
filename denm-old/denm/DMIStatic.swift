import UIKit
import QuartzCore

/**
Dynamic Marking Interpolation: Static
*/
class DMIStatic: DMInterpolation {
    
    var stopLineHeight: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    override func addComponents() -> DMInterpolation {
        addHorizontalLine()
        addVerticalLine()
        return self
    }
    
    func addHorizontalLine() {
        let primaryLine: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0.5 * height))
        path.addLineToPoint(CGPointMake(width, 0.5 * height))
        primaryLine.path = path.CGPath
        setVisualAttributes(primaryLine)
        addSublayer(primaryLine)
    }
    
    func addVerticalLine() {

        let stopLine: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(width, 0))
        path.addLineToPoint(CGPointMake(width, height))
        stopLine.path = path.CGPath
        setVisualAttributes(stopLine)
        addSublayer(stopLine)
    }
    
    override func setKerningKey() {
        kerningKey = "-"
    }
    
}