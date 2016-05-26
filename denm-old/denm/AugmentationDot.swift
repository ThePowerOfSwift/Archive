import UIKit

/**
Augmentation Dot
*/
class AugmentationDot: CAShapeLayer {
    
    // MARK: Position
    
    /// Horizontal center of an AugmentationDot
    var x: CGFloat = 0
    
    /// Vertical center of an AugmentationDot
    var y: CGFloat = 0
    
    /// Diameter of an AugmentationDot
    var width: CGFloat = 0
    
    /// Color of an AugmentationDot
    var color: CGColor = UIColor.lightGrayColor().CGColor
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    /**
    Set horizontal center of an Augmentation Dot
    
    :param: x Horizontal center of an Augmentation Dot
    
    :returns: Self: AugmentationDot
    */
    func setX(x: CGFloat) -> AugmentationDot {
        self.x = x
        return self
    }
    
    /**
    Set vertical center of an AugmentationDot
    
    :param: y Vertical center of an AugmentationDot
    
    :returns: Self: AugmentationDot
    */
    func setY(y: CGFloat) -> AugmentationDot {
        self.y = y
        return self
    }
    
    /**
    Set diameter of an AugmentationDot
    
    :param: width Diameter of an AugmentationDot
    
    :returns: Self: AugmentationDot
    */
    func setWidth(width: CGFloat) -> AugmentationDot {
        self.width = width
        return self
    }
    
    func setColor(color: CGColor) -> AugmentationDot {
        self.color = color
        return self
    }
    
    /**
    Add necessary components to AugmentationDot
    
    :returns: Self: AugmentationDots
    */
    func build() -> AugmentationDot {
        path = makePath()
        setVisualAttributes()
        return self
    }
    
    private func setVisualAttributes() {
        fillColor = UIColor.darkGrayColor().CGColor
        lineWidth = 0
    }
    
    private func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath(
            ovalInRect: CGRectMake(x - 0.5 * width, y - 0.5 * width, width, width)
        )
        return path.CGPath
    }
}