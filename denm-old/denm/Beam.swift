import UIKit
import QuartzCore

/**
Beam: more discussion needed
*/
class Beam: CAShapeLayer {
    
    // MARK: Attributes
    
    /// Width of Beam
    var width: CGFloat = 0
    
    /// Top of Beam
    var top: CGFloat = 0
    
    /// x-value of starting point of Beam
    var start: CGFloat = 0
    
    /// x-value of ending point of Beam
    var end: CGFloat = 0
    
    // MARK: Create a Beam
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a Beam
    
    /**
    Set width of Beam
    
    :param: width Width of Beam
    
    :returns: Self: Beam
    */
    func setWidth(width: CGFloat) -> Beam {
        self.width = width
        return self
    }
    
    /**
    Set top of Beam
    
    :param: top Top of Beam
    
    :returns: Self: Beam
    */
    func setTop(top: CGFloat) -> Beam {
        self.top = top
        return self
    }
    
    /**
    Set x-value of starting point of Beam
    
    :param: start x-value of starting point of Beam
    
    :returns: Self: Beam
    */
    func setStart(start: CGFloat) -> Beam {
        self.start = start
        return self
    }
    
    /**
    Set x-value of ending point of Beam
    
    :param: end x-value of starting point of Beam
    
    :returns: Self: Beam
    */
    func setEnd(end: CGFloat) -> Beam {
        self.end = end
        return self
    }
    
    /**
    Set color of Beam
    
    :param: color Color of Beam
    
    :returns: Self: Beam
    */
    func setColor(color: CGColor) -> Beam {
        fillColor = color
        return self
    }
    
    /**
    Create path of Beam
    
    :returns: Self: Beam
    */
    func build() -> Beam {
        let _path: UIBezierPath = UIBezierPath()
        _path.moveToPoint(CGPointMake(start, top))
        _path.addLineToPoint(CGPointMake(end, top))
        _path.addLineToPoint(CGPointMake(end, top + width))
        _path.addLineToPoint(CGPointMake(start, top + width))
        _path.closePath()
        path = _path.CGPath
        return self
    }
}