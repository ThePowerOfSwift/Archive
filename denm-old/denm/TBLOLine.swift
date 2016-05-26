import QuartzCore
import UIKit

/**
TBLOLine (Tuplet Bracket Ligature Ornament Line)
*/
class TBLOLine: TBLOrnament {
    
    // MARK: Size
    
    var g: CGFloat = 0
    
    var width: CGFloat { get { return g } }
    
    // MARK: Position
    
    var x: CGFloat = 0
    
    var y: CGFloat = 0
    
    // MARK: Visual Attributes
    
    var color: CGColor = UIColor.lightGrayColor().CGColor
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    func setSize(#g: CGFloat) -> TBLOLine {
        self.g = g
        return self
    }
    
    func setX(x: CGFloat) -> TBLOLine {
        self.x = x
        return self
    }
    
    func setY(y: CGFloat) -> TBLOLine {
        self.y = y
        return self
    }
    
    func setColor(color: CGColor) -> TBLOLine {
        self.color = color
        return self
    }
    
    func build() -> TBLOLine {
        path = makePath()
        setVisualAttributes()
        return self
    }
    
    func setVisualAttributes() {
        strokeColor = color
    }
    
    internal func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(x - 0.5 * width, y))
        path.addLineToPoint(CGPointMake(x + 0.5 * width, y))
        return path.CGPath
    }
}