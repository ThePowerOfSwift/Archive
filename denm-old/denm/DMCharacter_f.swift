import UIKit
import QuartzCore

class DMCharacter_f: DMCharacter {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addComponents() -> DMCharacter {
        addDownStroke()
        addCrossStroke()
        return self
    }
    
    func addCrossStroke() -> DMCharacter_f {
        let crossStrokeLength: CGFloat = 0.5 * width
        line.moveToPoint(CGPointMake(0.618 * width - 0.5 * crossStrokeLength, xHeight))
        line.addLineToPoint(CGPointMake(0.618 * width + 0.5 * crossStrokeLength, xHeight))
        return self
    }
    
    func addDownStroke() -> DMCharacter_f {
        line.moveToPoint(CGPointMake(0, restLine))
        line.addLineToPoint(CGPointMake(0.236 * width, height))
        line.addLineToPoint(CGPointMake(0.618 * width, xHeight))
        line.addCurveToPoint(
            CGPointMake(width, capHeight),
            controlPoint1: CGPointMake(0.825 * width, -0.1236 * height),
            controlPoint2: CGPointMake(width, capHeight)
        )
        return self
    }
    
    override func setWidth() -> DMCharacter {
        width = baseline - xHeight
        return self
    }
    
    override func setKerningKey() {
        kerningKey = "f"
    }
}