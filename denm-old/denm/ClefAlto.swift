import UIKit
import QuartzCore

/**
ClefAlto
*/
class ClefAlto: StaffClef {
    
    /**
    Add decorator: diamond on "c" line
    */
    override func addDecorator() {
        
        // diamond
        var width = 0.618 * g
        var rect = CGRectMake(0, 0, width, width)
        var path = UIBezierPath(rect: rect)
        
        decorator.frame = CGRectMake(
            0.5 * self.width,
            2 * g + lineExtension - 0.5 * width - lineWidth,
            width,
            width
        )
        // Rotate 45 degrees
        decorator.transform = CATransform3DMakeRotation(
            45.0 / 180.0 * CGFloat(M_PI), 0.0, 0.0, 1.0
        )
        
        decorator.path = path.CGPath
        decorator.lineWidth = lineWidth
        decorator.strokeColor = color
        decorator.fillColor = UIColor.whiteColor().CGColor
        self.addSublayer(decorator)
    }
    
    override func setMiddleCStaffSpace() {
        middleCStaffSpace = -2
    }
}