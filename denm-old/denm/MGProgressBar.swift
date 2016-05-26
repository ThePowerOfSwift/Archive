import UIKit

class MGProgressBar: CAShapeLayer {
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Horizontal length of MGProgressBar
    var length: CGFloat = 0
    
    // MARK: Position
    
    /// Left of MGProgressBar
    var left: CGFloat = 0
    
    /// Altitude of MGProgressBar
    var altitude: CGFloat = 0
    
    // MARK: Visual Attributes
    
    /// Color of MGProgressBar
    var color: CGColor = UIColor.redColor().CGColor
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build an MGProgressBar
    
    /**
    Set size of MGProgressBar
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: MGProgressBar
    */
    func setSize(#g: CGFloat) -> MGProgressBar {
        self.g = g
        return self
    }
    
    /**
    Set horizontal length of MGProgressBar
    
    :param: length Horizontal length of MGProgressBar
    
    :returns: Self: MGProgressBar
    */
    func setLength(length: CGFloat) -> MGProgressBar {
        self.length = length
        return self
    }
    
    /**
    Set vertical center of MGProgressBar
    
    :param: altitude Vertical center of MGProgressBar
    
    :returns: Self: MGProgressBar
    */
    func setAltitude(altitude: CGFloat) -> MGProgressBar {
        self.altitude = altitude
        return self
    }
    
    /**
    Set color of MGProgressBar
    
    :param: color Color of MGProgressBar
    
    :returns: Self: MGProgressBar
    */
    func setColor(color: CGColor) -> MGProgressBar {
        self.color = color
        return self
    }
    
    /**
    Add necessary components and attributes to MGProgressBar
    
    :returns: Self: MGProgressBar
    */
    func build() -> MGProgressBar {
        path = makePath()
        setVisualAttributes()
        return self
    }

    /**
    Animate MGProgressBar from left-to-right over desired duration
    
    :param: duration Duration of animation
    
    :returns: Self: MGProgressBar
    */
    func animateWithDuration(duration: Double) -> MGProgressBar {
        let animation = CABasicAnimation()
        animation.duration = duration
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        addAnimation(animation, forKey: "strokeEnd")
        removeAfterDuration(duration)
        return self
    }
    
    internal func removeAfterDuration(duration: Double) {
        var timer: NSTimer = NSTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(duration,
            target: self,
            selector: Selector("remove"),
            userInfo: nil,
            repeats: false
        )
    }
    
    internal func remove() {
        //CATransaction.setDisableActions(true)
        removeFromSuperlayer()
        //CATransaction.setDisableActions(false)
    }

    internal func setVisualAttributes() {
        lineWidth = 2 // make relative
        strokeColor = color
    }
    
    internal func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(0, altitude))
        path.addLineToPoint(CGPointMake(length, altitude))
        return path.CGPath
    }
}