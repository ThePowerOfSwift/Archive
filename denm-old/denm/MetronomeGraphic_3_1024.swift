import QuartzCore
import UIKit

class MetronomeGraphic_3_1024: MetronomeGraphic {
    
    // THESE ARE COPIED FROM 3_64: REDEFINE
    
    override func setSize(#g: CGFloat) -> MetronomeGraphic {
        height = 1 * g
        width = 1 * g
        return self
    }
    
    override func build() -> MetronomeGraphic {
        
        line.moveToPoint(CGPointMake(0.5 * width, 0))
        line.addLineToPoint(CGPointMake(width, height))
        line.addLineToPoint(CGPointMake(0, height))
        line.closePath()
        
        path = line.CGPath
        fillColor = UIColor.lightGrayColor().CGColor
        return self
    }
    
    override func highlight() {
        fillColor = UIColor.redColor().CGColor
    }
}