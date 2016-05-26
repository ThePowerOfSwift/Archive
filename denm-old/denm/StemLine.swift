import UIKit
import QuartzCore

class StemLine: CAShapeLayer {
    
    var x: CGFloat = 0
    var top: CGFloat = 0
    var bottom: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    func setX(x: CGFloat) -> StemLine {
        self.x = x
        return self
    }
    
    func setTop(top: CGFloat) -> StemLine {
        // something
        self.top = top
        return self
    }
    
    func setBottom(bottom: CGFloat) -> StemLine {
        // something
        self.bottom = bottom
        return self
    }
    
    func setWidth(width: CGFloat) -> StemLine {
        self.lineWidth = width
        return self
    }
    
    func setColor(color: CGColor) -> StemLine {
        strokeColor = color
        return self
    }
    
    func build() -> StemLine {
        makePath()
        return self
    }
    
    func rebuild() -> StemLine {
        makeAnimationToNewPath(makePath())
        return self
    }
    
    func makePath() -> CGPath {
        let _path: UIBezierPath = UIBezierPath()
        _path.moveToPoint(CGPointMake(x, top))
        _path.addLineToPoint(CGPointMake(x, bottom))
        path = _path.CGPath
        return path
    }
}