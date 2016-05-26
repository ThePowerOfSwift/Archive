import UIKit
import QuartzCore

class TestLineArrow: TestLineComponent {
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    var width: CGFloat = 0
    var height: CGFloat = 0
    var rotate: CGFloat = 0 // default pointing up
    
    //let line: UIBezierPath = UIBezierPath()
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, rotate: CGFloat) {
        self.x = x
        self.y = y
        self.width = width
        self.height = 0.666 * width
        self.rotate = rotate
        super.init()
        build()
    }
    
    func build() {
        println("building arrow")
        line.moveToPoint(CGPointMake(0, height))
        line.addLineToPoint(CGPointMake(0.5 * width, 0))
        line.addLineToPoint(CGPointMake(width, height))
        frame = CGRectMake(x - 0.5 * width, y, width, 0)
        transform = CATransform3DMakeRotation(rotate / 180.0 * CGFloat(M_PI), 0, 0, 1.0)

        path = line.CGPath
        borderColor = UIColor.greenColor().CGColor
        borderWidth = 1
        lineWidth = 1
        fillColor = UIColor.clearColor().CGColor
        opacity = 0.5
    }
}