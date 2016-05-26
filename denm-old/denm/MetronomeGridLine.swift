import UIKit

class MetronomeGridLine: CAShapeLayer {
    
    var x: CGFloat = 0
    var top: CGFloat = 0
    var bottom: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    /**
    Set horizontal center of a MetronomeGridLine
    
    :param: x Horizontal center of a MetronomeGridLine
    
    :returns: Self: MetronomeGridLine
    */
    func setX(x: CGFloat) -> MetronomeGridLine {
        self.x = x
        return self
    }
    
    /**
    Set top of a MetronomeGridLine
    
    :param: top Top of a MetronomeGridLine
    
    :returns: Self: MetronomeGridLine
    */
    func setTop(top: CGFloat) -> MetronomeGridLine {
        self.top = top
        return self
    }
    
    /**
    Set bottom of a MetronomeGridLine
    
    :param: bottom Bottom of a MetronomeGridLine
    
    :returns: Self: MetronomeGridLine
    */
    func setBottom(bottom: CGFloat) -> MetronomeGridLine {
        self.bottom = bottom
        return self
    }
    
    func build() -> MetronomeGridLine {
        path = makePath()
        setVisualAttributes()
        return self
    }
    
    func resize() -> MetronomeGridLine {
        let animation = makeAnimationToNewPath(makePath())
        addAnimation(animation, forKey: nil)
        return self
    }
    
    func setVisualAttributes() {
        strokeColor = UIColor.redColor().CGColor
        opacity = 0.25
    }
    
    func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(x, top))
        path.addLineToPoint(CGPointMake(x, bottom))
        return path.CGPath
    }
}