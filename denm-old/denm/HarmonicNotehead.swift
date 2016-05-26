import UIKit
import QuartzCore

/**
HarmonicNoteheaf
*/
class HarmonicNotehead: Notehead {
    
    /**
    Set all necessary visual attributes of Noteheas
    
    :returns: Self: Notehead
    */
    override func build() -> Notehead {
        var width = 0.8 * g
        var rect = CGRectMake(0, 0, width, width)
        var path = UIBezierPath(rect: rect)
        frame = CGRectMake(
            x - 0.5 * width,
            y - 0.5 * width,
            width,
            width
        )
        transform = CATransform3DMakeRotation(45.0 / 180.0 * CGFloat(M_PI), 0.0, 0.0, 1.0)
        self.path = path.CGPath
        lineWidth = 0.1618 * g
        strokeColor = color
        fillColor = UIColor.whiteColor().CGColor
        return self
    }
}