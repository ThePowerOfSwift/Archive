import QuartzCore
import UIKit

/**
TBLOCircle (Tuplet Bracket Ligature Ornament Circle)
*/
class TBLOCircle: TBLOrnament {
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Width of TBLOCircle
    var width: CGFloat { get { return 0.8375 * g } }
    
    // MARK: Position
    
    /// Horizontal center of circle
    var x: CGFloat = 0
    
    /// Vertical center of circle
    var y: CGFloat = 0
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }

    /**
    Set size of TBLOCircle
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: TBLOCircle
    */
    func setSize(#g: CGFloat) -> TBLOCircle {
        self.g = g
        self.lineWidth = 0.125 * g
        return self
    }

    /**
    Set horizontal center of TBLOCircle
    
    :param: x Horizontal center of TBLOCircle
    
    :returns: Self: TBLOCircle
    */
    func setX(x: CGFloat) -> TBLOCircle {
        self.x = x
        return self
    }
    
    /**
    Set vertical center of TBLOCircle
    
    :param: y Vertical center of TBLOCircle
    
    :returns: Self: TBLOCircle
    */
    func setY(y: CGFloat) -> TBLOCircle {
        self.y = y
        return self
    }
    
    /**
    Set all necessary visual attributes to TBLOCircle
    
    :returns: Self: TBLOCircle
    */
    func build() -> TBLOCircle {
        setFrame()
        path = makePath()
        setVisualAttributes()
        return self
    }
    
    func setVisualAttributes() {
        strokeColor = UIColor.lightGrayColor().CGColor
        fillColor = UIColor.whiteColor().CGColor
    }
    
    internal func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath(
            ovalInRect: CGRectMake(0, 0, width, width)
        )
        return path.CGPath
    }
    
    override func setFrame() {
        frame = CGRectMake(x - 0.5 * width, y - 0.5 * width, width, width)
    }
}