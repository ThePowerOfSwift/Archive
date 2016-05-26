import QuartzCore
import UIKit

/**
TBLLine (Tuplet Bracket Ligature Line)
*/
class TBLLine: TBLComponent {
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    // MARK: Position
    
    /// x-value of TBLLine
    var x: CGFloat = 0
    
    /// y-value of beamEnd of TBLLine
    var top: CGFloat = 0
    
    /// y-value of bracketEnd of TBLLine
    var bottom: CGFloat = 0
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a TBLLine
    
    /**
    Set size of TBLLine with graphical height of a single Guidonian staff space
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: TBLLine
    */
    func setSize(#g: CGFloat) -> TBLLine {
        self.g = g
        lineWidth = 0.08375 * g
        return self
    }
    
    /**
    Set horizontal position of line
    
    :param: x Horizontal position of line
    
    :returns: Self: TBLLine
    */
    func setX(x: CGFloat) -> TBLLine {
        self.x = x
        return self
    }
    
    func setTop(top: CGFloat) -> TBLLine {
        self.top = top
        return self
    }
    
    func setBottom(bottom: CGFloat) -> TBLLine {
        self.bottom = bottom
        return self
    }
    
    
    /**
    Complete necessary components of TBLLine
    
    :returns: Self: TBLLine
    */
    func build() -> TBLLine {
        path = makePath()
        strokeColor = UIColor.lightGrayColor().CGColor
        return self
    }
    
    /**
    Resize TBLLine when external context has changed
    */
    func resize() {
        animateToPath(makePath())
    }
    
    func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(x, top))
        path.addLineToPoint(CGPointMake(x, bottom))
        return path.CGPath
    }
    
    func animateToPath(path: CGPath) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation.toValue = path
        animation.timingFunction = CAMediaTimingFunction(name: "default")
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        addAnimation(animation, forKey: nil)
    }
}