import QuartzCore
import UIKit

/**
TBLOArrow (Tuplet Bracket Ligature Ornament Arrow)
*/
class TBLOArrow: TBLOrnament {
    
    // MARK: Size
    
    var g: CGFloat = 0
    
    var height: CGFloat { get { return 0.8375 * g } }
    
    var width: CGFloat { get { return 0.8375 * g } }
    
    var barb: CGFloat { get { return 0.33 * height } }
    
    // MARK: Position
    
    /// Horizontal center of TBLOArrow
    var x: CGFloat = 0
    
    var tipY: CGFloat = 0
    
    var o: CGFloat = 0
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    func setSize(#g: CGFloat) -> TBLOArrow {
        self.g = g
        return self
    }
    
    func setX(x: CGFloat) -> TBLOArrow {
        self.x = x
        return self
    }
    
    func setTipY(tipY: CGFloat) -> TBLOArrow {
        self.tipY = tipY
        return self
    }
    
    func setOrientation(orientation: CGFloat) -> TBLOArrow {
        self.o = orientation
        return self
    }
    
    func build() -> TBLOArrow {
        setFrame()
        path = makePath()
        fillColor = UIColor.lightGrayColor().CGColor
        return self
    }
    
    func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        let tipRelY = o > 0 ? 0 : height
        let barbRelY = o > 0 ? height : 0
        path.moveToPoint(CGPointMake(0.5 * width, tipRelY))
        path.addLineToPoint(CGPointMake(0, barbRelY))
        path.addLineToPoint(CGPointMake(0.5 * width, barbRelY - o * barb))
        path.addLineToPoint(CGPointMake(width, barbRelY))
        path.closePath()
        return path.CGPath
    }
    
    override func setFrame() {
        let top = o > 0 ? tipY : tipY - height
        frame = CGRectMake(x - 0.5 * width, top, width, height)
    }
}