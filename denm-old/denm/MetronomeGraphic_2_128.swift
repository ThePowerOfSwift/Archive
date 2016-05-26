import QuartzCore
import UIKit

class MetronomeGraphic_2_128: MetronomeGraphic {
    
    // THESE ARE COPIED FROM 2_64: REDEFINE
    
    override func setSize(#g: CGFloat) -> MetronomeGraphic {
        height = 1 * g
        width = 1 * g
        return self
    }
    
    override func build() -> MetronomeGraphic {
        
        line.moveToPoint(CGPointMake(0, 0))
        line.addLineToPoint(CGPointMake(width, 0))
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