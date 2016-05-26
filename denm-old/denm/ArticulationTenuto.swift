import UIKit

/**
ArticulationTenuto
*/
class ArticulationTenuto: Articulation {
    
    /// Width of ArticulationTenuto
    var width: CGFloat { get { return 1.236 * g } }
    
    override func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(x - 0.5 * width, y))
        path.addLineToPoint(CGPointMake(x + 0.5 * width, y))
        return path.CGPath
    }
    
    override func setVisualAttributes() {
        strokeColor = color
    }
}