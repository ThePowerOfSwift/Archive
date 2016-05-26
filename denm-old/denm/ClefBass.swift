import UIKit
import QuartzCore

/**
ClefBass
*/
class ClefBass: StaffClef {
    
    /**
    Add decorator: two dots surrounding "f" line
    */
    override func addDecorator() {
        var path = UIBezierPath()
        var radius = 0.1545 * g
        var startAngle: CGFloat = 0
        var endAngle: CGFloat = CGFloat(M_PI) * 2
        var dotΔX: CGFloat = 0.5 * width + 0.618 * g
        var dotΔY: CGFloat = 0.4 * g
        
        var dot = -1
        while dot < 2 {
            var center = CGPointMake(dotΔX, g + lineExtension + dotΔY * CGFloat(dot))
            path.addArcWithCenter(center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true
            )
            dot += 2
        }

        decorator.path = path.CGPath
        decorator.lineWidth = 0
        decorator.strokeColor = color
        decorator.fillColor = color
        self.addSublayer(decorator)
    }
    
    override func setMiddleCStaffSpace() {
        middleCStaffSpace = 1
    }
}