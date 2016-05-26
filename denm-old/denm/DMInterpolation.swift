import UIKit
import QuartzCore

/**
Dynamic Marking Interpolations:

- Hairpin (cresc., decresc.; linear, or with exponent)
- Swell (convex, concave; linear or with exponent)
- Static
*/
class DMInterpolation: StratumObject {
    
    var kerningKey: String = "-"
    
    // MARK: Size
    
    var height: CGFloat = 0
    var width: CGFloat = 0
    var lineWidth: CGFloat = 0
    
    // MARK: Position
    
    var x0: CGFloat?
    var x1: CGFloat?
    var y: CGFloat = 0
    var left: CGFloat = 0
    var top: CGFloat = 0
    
    // MARK: Create a DMInterpolation
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(layer: AnyObject) { super.init(layer: layer) }
    override init() { super.init(); setKerningKey() }
    
    func setY(y: CGFloat) -> DMInterpolation {
        self.y = y
        return self
    }
    
    func setHeight(height: CGFloat) -> DMInterpolation {
        self.height = height
        self.lineWidth = 0.1618 * height
        return self
    }
    
    func setX0(x0: CGFloat) -> DMInterpolation {
        self.x0 = x0
        return self
    }
    
    func setX1(x1: CGFloat) -> DMInterpolation {
        self.x1 = x1
        return self
    }
    
    func build() -> DMInterpolation {
        setFrame()
        addComponents()
        return self
    }
    
    func addComponents() -> DMInterpolation {
        /* override for each subclass */
        return self
    }
    
    override func setFrame() {
        top = y - 0.5 * height
        width = x1! - x0!
        frame = CGRectMake(x0!, top, width, height)
    }
    
    func setKerningKey() {
        /* override in each subclass */
    }
    
    func setVisualAttributes(shapeLayer: CAShapeLayer) {
        /* override if necessary */
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = UIColor.grayColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
    }
}