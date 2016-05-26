import UIKit
import QuartzCore

/**
OrdNotehead
*/
class OrdNotehead: Notehead {
    
    /**
    Set all necessary visual attributes of Notehead
    
    :returns: Self: Notehead
    */
    override func build() -> Notehead {
        let width = 1.382 * g
        let height = 0.675 * width
        let rect = CGRectMake(0, 0, width, height)
        let path = UIBezierPath(ovalInRect: rect)
        frame = CGRectMake(x - 0.5 * width, y - 0.5 * height, width, height)
        transform = CATransform3DMakeRotation( -45.0 / 180.0 * CGFloat(M_PI), 0.0, 0.0, 1.0 )
        self.path = path.CGPath
        lineWidth = 0
        strokeColor = UIColor.clearColor().CGColor
        fillColor = color
        return self
    }
}