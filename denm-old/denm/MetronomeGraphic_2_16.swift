import QuartzCore
import UIKit

/**
MetronomeGraphic for 2 16th-notes


*/
class MetronomeGraphic_2_16: MetronomeGraphic {
    
    var inset: CGFloat = 0
    
    override func setSize(#g: CGFloat) -> MetronomeGraphic {
        height = 2 * g
        width = 2 * g
        //lineWidth = 0.01618 * height
        lineWidth = 1
        return self
    }
    
    override func build() -> MetronomeGraphic {
        inset = 0.1 * width
        
        // outer square
        line.moveToPoint(CGPointMake(0, 0))
        line.addLineToPoint(CGPointMake(width, 0))
        line.addLineToPoint(CGPointMake(width, height))
        line.addLineToPoint(CGPointMake(0, height))
        line.closePath()
        
        // inner square
        line.moveToPoint(CGPointMake(0 + inset, 0 + inset))
        line.addLineToPoint(CGPointMake(width - inset, 0 + inset))
        line.addLineToPoint(CGPointMake(width - inset, height - inset))
        line.addLineToPoint(CGPointMake(0 + inset, height - inset))
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