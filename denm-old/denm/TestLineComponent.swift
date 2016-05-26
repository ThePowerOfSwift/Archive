import UIKit
import QuartzCore

class TestLineComponent: CAShapeLayer {
    
    var color: CGColor = UIColor.lightGrayColor().CGColor
    let line: UIBezierPath = UIBezierPath()
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
}