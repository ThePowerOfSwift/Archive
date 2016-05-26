import QuartzCore
import UIKit

/**
MetronomeGraphic for 3 64th-notes
*/
class MetronomeGraphic_3_64: MetronomeGraphic {
    
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
        fillColor = color_default
        return self
    }
    
    override func highlight() {
        fillColor = color_highlighted
    }
    
    override func deHighlight() {
        fillColor = color_default
    }
}