import UIKit
import QuartzCore

class PerformerBracket: CAShapeLayer {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    // Size ===================================================================================
    var g: CGFloat = 0
    var height: CGFloat = 0
    var width: CGFloat = 0
    
    // Position ===============================================================================
    var top: CGFloat = 0
    var left: CGFloat = 0
    var bottom: CGFloat = 0
    
    func setSize(g: CGFloat) -> PerformerBracket {
        self.g = g
        self.width = 1.236 * g
        return self
    }
    
    func setHeight(height: CGFloat) -> PerformerBracket {
        self.height = height
        return self
    }
    
    func setTop(top: CGFloat) -> PerformerBracket {
        self.top = top
        self.bottom = top + height
        return self
    }
    
    func setLeft(left: CGFloat) -> PerformerBracket {
        self.left = left
        return self
    }
    
    func build() -> PerformerBracket {
        path = makePath()
        strokeColor = UIColor.grayColor().CGColor
        lineWidth = 0.238 * g
        fillColor = UIColor.clearColor().CGColor
        return self
    }
    
    func resize(#top: CGFloat, height: CGFloat) {
        self.top = top
        self.height = height
        self.bottom = top + height
        animateToPath(makePath())
    }
    
    func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(width, 0))
        path.addLineToPoint(CGPointMake(0, width))
        path.addLineToPoint(CGPointMake(0, bottom - width))
        path.addLineToPoint(CGPointMake(width, bottom))
        return path.CGPath
    }
    
    func animateToPath(path: CGPath) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation.toValue = path
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: "default")
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        addAnimation(animation, forKey: nil)
    }
}