import UIKit
import QuartzCore

class TestLineEdge: TestLineComponent {
    
    var x0: CGFloat = 0
    var y0: CGFloat = 0
    var x1: CGFloat = 0
    var y1: CGFloat = 0
    
    //let line: UIBezierPath = UIBezierPath()
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    init(x0: CGFloat, y0: CGFloat, x1: CGFloat, y1: CGFloat) {
        self.x0 = x0
        self.y0 = y0
        self.x1 = x1
        self.y1 = y1
        super.init()
        build()
    }
    
    func build() {
        println("building edge")
        line.moveToPoint(CGPointMake(x0, y0))
        line.addLineToPoint(CGPointMake(x1, y1))
        path = line.CGPath
        lineWidth = 1
        opacity = 0.5
    }
}