import UIKit

class Tremolo: CAShapeLayer {
    
    // MARK: Attributes

    /// Amount of Beams in Tremolo
    var amountBeams: Int = 1
    
    /// Slope of Beams in Tremolo
    var slope: CGFloat = 0.25
    
    /// Displacement of each beam
    var beamΔY: CGFloat = 0
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Width of Tremolo
    var width: CGFloat = 0
    
    // MARK: Position
    
    /// Horizontal center of Tremolo
    var x: CGFloat = 0
    
    /// Vertical center of Tremolo
    var y: CGFloat = 0
    
    /// Top of Tremolo
    var top: CGFloat = 0
    
    /// Left of Tremolo
    var left: CGFloat = 0
    
    /// Right of Tremolo
    var right: CGFloat = 0
    
    // MARK: Visual Attributes
    
    /// Color of Tremolo
    var color: CGColor = UIColor.blackColor().CGColor
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }

    // MARK: Incrementally build a Tremolo
    
    /**
    Set horizontal center of a Tremolo
    
    :param: x Horizontal center of a Tremolo
    
    :returns: Self: Tremolo
    */
    func setX(x: CGFloat) -> Tremolo {
        self.x = x
        return self
    }
    
    /**
    Set vertical center of a Tremolo
    
    :param: y Vertical center of a Tremolo
    
    :returns: Self: Tremolo
    */
    func setY(y: CGFloat) -> Tremolo {
        self.y = y
        return self
    }
    
    /**
    Set size of a Tremoloe
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: Tremolo
    */
    func setSize(#g: CGFloat) -> Tremolo {
        self.g = g
        return self
    }
    
    /**
    Set left of a Tremolo
    
    :param: left Left of a Tremolo
    
    :returns: Self: Tremolo
    */
    func setLeft(left: CGFloat) -> Tremolo {
        self.left = left
        return self
    }
    
    /**
    Set top of a Tremolo
    
    :param: top Top of a Tremolo
    
    :returns: Self: Tremolo
    */
    func setTop(top: CGFloat) -> Tremolo {
        self.top = top
        return self
    }
    
    /**
    Set right of a Tremolo
    
    :param: right Right of a Tremolo
    
    :returns: Self: Tremolo
    */
    func setRight(right: CGFloat) -> Tremolo {
        self.right = right
        return self
    }
    
    func build() -> Tremolo {
        setFrame()
        path = makePath()
        setVisualComponents()
        return self
    }
    
    func setFrame() {
        width = right - left
        let height: CGFloat = 30 // temp
        frame = CGRectMake(left, top, width, height)
    }
    
    internal func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        
        // embded in loop for multiple beams
        
        // tl
        path.moveToPoint(CGPointMake(0, 0.5 * frame.width * slope + 0)) // add slope
        // tr
        path.addLineToPoint(CGPointMake(frame.width, -0.5 * frame.width * slope)) // add slope
        // br
        path.addLineToPoint(CGPointMake(frame.width, frame.height - 0.5 * frame.width * slope))
        // bl
        path.addLineToPoint(CGPointMake(0, frame.height + 0.5 * frame.width * slope))
        path.closePath()
        return path.CGPath
    }
    
    internal func setVisualComponents() {
        fillColor = color
    }
}