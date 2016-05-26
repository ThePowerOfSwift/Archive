import QuartzCore
import UIKit

/**
MetronomeGraphic for 3 16th-notes

Here is an image: ![3_16](../img/MetronomeGraphic_3_16.png)
*/
class MetronomeGraphic_3_16: MetronomeGraphic {
    
    /**
    Here is an example image: ![3_16](../img/MetronomeGraphic_3_16.png)
    */
    var inset: CGFloat = 0
    
    override func setSize(#g: CGFloat) -> MetronomeGraphic {
        height = 2 * g
        width = 2 * g
        //lineWidth = 0.01618 * height
        lineWidth = 1
        return self
    }
    
    // CHANGE FOR TRIANGLE!
    override func build() -> MetronomeGraphic {
        inset = 0.1 * width
        
        // outer square
        line.moveToPoint(CGPointMake(0.5 * width, -0.1 * height))
        line.addLineToPoint(CGPointMake(1.1 * width, height))
        line.addLineToPoint(CGPointMake(-0.1 * width, height))
        line.closePath()
        
        // inner square
        line.moveToPoint(CGPointMake(0.5 * width, 0 + inset))
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