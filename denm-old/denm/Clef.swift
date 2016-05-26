import UIKit
import QuartzCore

/**
Clef
*/
class Clef: CALayer {
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Height of Clef
    var height: CGFloat = 0
    
    /// Width of Clef
    var width: CGFloat = 0
    
    /// Width of GraphLines
    var lineWidth: CGFloat = 0
    
    /// Length of Clef line beyond Graph (per each end)
    var lineExtension: CGFloat = 0
    
    // MARK: Position
    
    /// Horizontal position of Clef
    var x: CGFloat = 0
    
    /// Top of Clef
    var top: CGFloat = 0
    
    // MARK: Components
    
    /// Clef line
    var line = CAShapeLayer()
    
    /// Clef decorator
    var decorator = CAShapeLayer()
    
    // MARK: Visual Attributes
    
    /// Color of Clef
    var color = UIColor.redColor().CGColor
    
    // Init ===================================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    override init!() { super.init() }
    
    // MARK: Incrementally build a Clef
    
    /**
    Set size of Clef with Graphical height of a single Guidonian staff space and height
    
    :param: g      Graphical height of a single Guidonian staff space
    :param: height Height of Clef
    
    :returns: Self: Clef
    */
    func setSize(g: CGFloat, height: CGFloat) -> Clef {
        self.g = g
        self.height = height
        self.lineWidth = 0.1 * g // make getter
        self.lineExtension = 0.618 * g // make getter
        self.width = 1.236 * g // make getter
        return self
    }
    
    /**
    Set horizontal position of Clef
    
    :param: x Horizontal position of Clef
    
    :returns: Self: Clef
    */
    func setX(x: CGFloat) -> Clef {
        self.x = x
        return self
    }
    
    /**
    Set top of Clef
    
    :param: top Top of Clef
    
    :returns: Self: Clef
    */
    func setTop(top: CGFloat) -> Clef {
        self.top = top
        return self
    }
    
    /**
    Set position of Clef
    
    :param: x   Horizontal position of Clef
    :param: top Top of Clef
    
    :returns: Self: Clef
    */
    func setPosition(x: CGFloat, top: CGFloat) -> Clef {
        self.x = x
        self.top = top
        return self
    }
    
    /**
    Add all necessary components to Clef
    
    :returns: Self: Clef
    */
    func build() -> Clef {
        setFrame()
        addLine()
        addDecorator()
        return self
    }
    
    internal func addDecorator() {
        /* override in each subclass */
    }
    
    internal func addLine() {
        var path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(0.5 * width, 0))
        path.addLineToPoint(CGPointMake(0.5 * width, height))
        line.path = path.CGPath
        line.lineWidth = lineWidth
        line.strokeColor = color
        line.fillColor = UIColor.clearColor().CGColor
        self.addSublayer(line)
    }
    
    internal func setFrame() {
        top = top - lineExtension
        height = height + 2 * lineExtension
        frame = CGRectMake(x - 0.5 * width, top, width, height)
    }
}