import UIKit
import QuartzCore

/**
DurationalExtension: artist previously known as "tie"
*/
class DurationalExtension: CAShapeLayer {
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    // MARK: Position
    
    /// Left of DurationalExtension
    var left: CGFloat = 0
    
    /// Altitude of DurationalExtension
    var y: CGFloat = 0
    
    // MARK: Size
    
    /// Width of DurationalExtension
    var width: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a DurationalExtension
    
    /**
    Set size of DurationalExtension with Graphical height of a single Guidonian staff space
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: DurationalExtension
    */
    func setSize(#g: CGFloat) -> DurationalExtension {
        self.g = g
        return self
    }
    
    /**
    Set left of a DurationalExtension
    
    :param: left Left of a DurationalExtension
    
    :returns: Self: DurationalExtension
    */
    func setLeft(left: CGFloat) -> DurationalExtension {
        self.left = left
        return self
    }
    
    /**
    Set altitude of DurationalExtension
    
    :param: y Altitude of DurationalExtension
    
    :returns: Self: DurationalExtension
    */
    func setY(y: CGFloat) -> DurationalExtension {
        self.y = y
        return self
    }
    
    /**
    Set width of a DurationalExtension
    
    :param: width Width of a DurationalExtension
    
    :returns: Self: DurationalExtension
    */
    func setWidth(width: CGFloat) -> DurationalExtension {
        self.width = width
        return self
    }
    
    func build() -> DurationalExtension {
        path = makePath()
        setVisualAttributes()
        return self
    }
    
    func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(left, y))
        path.addLineToPoint(CGPointMake(left + width, y))
        return path.CGPath
    }
    
    func setVisualAttributes() {
        lineWidth = 0.25 * g
        strokeColor = UIColor.grayColor().CGColor
    }
}