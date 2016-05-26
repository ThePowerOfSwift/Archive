import UIKit

/**
ArticulationStaccato
*/
class ArticulationStaccato: Articulation {
    
    /// Width of ArticulationStaccato
    var width: CGFloat { get { return 0.382 * g } }
    
    override func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath(
            ovalInRect: CGRectMake(x - 0.5 * width, y - 0.5 * width, width, width)
        )
        return path.CGPath
    }
    
    override func setVisualAttributes() {
        fillColor = color
    }
}