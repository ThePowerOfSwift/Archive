import UIKit
import QuartzCore

class Barline: CAShapeLayer {

    var x: CGFloat = 0
    var top: CGFloat = 0
    var bottom: CGFloat = 0
    var width: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    func setX(x: CGFloat) -> Barline {
        self.x = x
        return self
    }
    
    func setTop(top: CGFloat) -> Barline {
        self.top = top
        return self
    }
    
    func setBottom(bottom: CGFloat) -> Barline {
        self.bottom = bottom
        return self
    }
    
    func build() -> Barline {
        path = makePath()
        setVisualAttributes()
        return self
    }
    
    func resize() -> Barline {
        let animation = makeAnimationToNewPath(makePath())
        addAnimation(animation, forKey: nil)
        return self
    }
    
    func makePath() -> CGPath {
        let _path: UIBezierPath = UIBezierPath()
        _path.moveToPoint(CGPointMake(x, top))
        _path.addLineToPoint(CGPointMake(x, bottom))
        return _path.CGPath
    }
    
    func setVisualAttributes() {
        lineWidth = 5
        strokeColor = UIColor.lightGrayColor().CGColor
        opacity = 0.2
    }
    
    func addComponents() {  
        let _path: UIBezierPath = UIBezierPath()
        _path.moveToPoint(CGPointMake(x, top))
        _path.addLineToPoint(CGPointMake(x, bottom))
        path = _path.CGPath
    }
}