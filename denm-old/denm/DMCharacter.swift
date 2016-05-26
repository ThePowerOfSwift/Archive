import UIKit
import QuartzCore

/**
Dynamic Marking Character:

- p
- f
- m
- o
- !
- (
- )
*/
class DMCharacter: CAShapeLayer {
    
    var kerningKey: String = ""
    
    // Size ===================================================================================
    var height: CGFloat = 0
    var width: CGFloat = 0
    
    // Position ===============================================================================
    var x: CGFloat = 0
    var left: CGFloat = 0
    var top: CGFloat = 0
    
    // Typographical ==========================================================================
    var italicAngle: CGFloat = 0
    var midLine: CGFloat = 0
    var xHeight: CGFloat = 0
    var capHeight: CGFloat = 0
    var baseline: CGFloat = 0
    var restLine: CGFloat = 0
    
    // Visual =================================================================================
    var color: CGColor = UIColor.blackColor().CGColor
    var line: UIBezierPath = UIBezierPath()
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    func setTop(top: CGFloat) -> DMCharacter {
        self.top = top
        return self
    }
    
    func setX(x: CGFloat) -> DMCharacter {
        self.x = x
        return self
    }
    
    func setHeight(height: CGFloat) -> DMCharacter {
        
        // These are sloppy: FOR TESTING ONLY!
        
        self.height = height
        self.capHeight = 0.0618 * height
        self.xHeight = 0.2 * height
        self.midLine = 0.5 * height
        self.baseline = 0.75 * height
        self.restLine = 0.9 * height
        self.lineWidth = 0.05 * height
        return self
    }
    
    func build() -> DMCharacter {
        setKerningKey()
        setFrame()
        addComponents()
        commitPath()
        setVisualAttributes()
        //borderColor = UIColor.lightGrayColor().CGColor
        //borderWidth = 1
        return self
    }
    
    func addComponents() -> DMCharacter {
        /* override in each subclass */
        return self
    }
    
    func setFrame() -> DMCharacter {
        setWidth()
        left = x - 0.5 * width
        frame = CGRectMake(left, top, width, height)
        return self
    }
    
    func setWidth() -> DMCharacter {
        /* override in each subclass */
        return self
    }
    
    func setKerningKey() {
        /* override in each subclass */
    }
    
    func setVisualAttributes() {
        lineJoin = kCALineJoinBevel
        strokeColor = color
        fillColor = UIColor.clearColor().CGColor
    }
    
    func commitPath() {
        path = line.CGPath
    }
}