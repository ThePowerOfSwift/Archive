import UIKit
import QuartzCore

class DMCharacter_o: DMCharacter {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addComponents() -> DMCharacter {
        line = UIBezierPath(ovalInRect:
            CGRectMake(0, midLine - 0.5 * width, width, width)
        )
        fillColor = UIColor.whiteColor().CGColor
        return self
    }
    
    override func setWidth() -> DMCharacter {
        width = 0.618 * (baseline - xHeight)
        return self
    }
    
    override func setKerningKey() {
        kerningKey = "o"
    }
}