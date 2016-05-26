import UIKit

/**
ArticulationAttack
*/
class ArticulationAttack: Articulation {
    
    /// Width of ArticulationAttack
    var width: CGFloat { get { return 1.118 * g } }
    
    /// Height of ArticulationAttack
    var height: CGFloat { get { return 0.5 * g } }

    override func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(x - 0.5 * width, y - 0.5 * height))
        path.addLineToPoint(CGPointMake(x + 0.5 * width, y))
        path.addLineToPoint(CGPointMake(x - 0.5 * width, y + 0.5 * height))
        return path.CGPath
    }
    
    override func setVisualAttributes() {
        lineJoin = kCALineJoinBevel
        fillColor = UIColor.clearColor().CGColor
        strokeColor = color
    }
}