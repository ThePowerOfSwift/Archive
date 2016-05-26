import UIKit
import QuartzCore

/**
ClefTreble
*/
class ClefTreble: StaffClef {
    
    /**
    Add decorator: circle on "g" line
    */
    override func addDecorator() {
        
        // circle on "g" line
        var path = UIBezierPath()
        var center = CGPointMake(0.5 * width, 3 * g + lineExtension)
        var radius = 0.382 * g
        var startAngle: CGFloat = 0
        var endAngle: CGFloat = CGFloat(M_PI) * 2
        
        // change to ovalInRect?
        
        path.addArcWithCenter(center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        decorator.path = path.CGPath
        decorator.lineWidth = lineWidth
        decorator.strokeColor = color
        decorator.fillColor = UIColor.whiteColor().CGColor
        self.addSublayer(decorator)
    }
    
    override func setMiddleCStaffSpace() {
        middleCStaffSpace = -5
    }
}