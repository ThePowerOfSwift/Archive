import QuartzCore
import UIKit

/**
MetronomeGraphic for 3 32nd-notes
*/
class MetronomeGraphic_3_32: MetronomeGraphic {

    override func setSize(#g: CGFloat) -> MetronomeGraphic {
        height = 1.236 * g
        width = 1.236 * g
        //lineWidth = 0.0236 * height
        lineWidth = 1
        return self
    }
    
    override func build() -> MetronomeGraphic {
        
        line.moveToPoint(CGPointMake(0.5 * width, 0))
        line.addLineToPoint(CGPointMake(width, height))
        line.addLineToPoint(CGPointMake(0, height))
        line.closePath()
        
        path = line.CGPath
        strokeColor = color_default
        fillColor = UIColor.whiteColor().CGColor
        return self
    }
    
    override func highlight() {
        strokeColor = color_highlighted
    }
    
    override func deHighlight() {
        strokeColor = color_default
    }
}