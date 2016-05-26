import UIKit
import QuartzCore

class SelectRect: CALayer {
    
    var initialPoint: CGPoint?

    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    func setInitialPoint(initialPoint: CGPoint) -> SelectRect {
        self.initialPoint = initialPoint
        setVisualAttributes()
        setFrame()
        return self
    }
    
    func setFrame() -> SelectRect {
        frame = CGRectMake(initialPoint!.x, initialPoint!.y, 0, 0)
        return self
    }
    
    func scaleToPoint(newPoint: CGPoint) -> SelectRect {
        let width: CGFloat = newPoint.x - initialPoint!.x
        let height: CGFloat = newPoint.y - initialPoint!.y
        CATransaction.setDisableActions(true)
        frame = CGRectMake(initialPoint!.x, initialPoint!.y, width, height)
        CATransaction.setDisableActions(false)
        return self
    }
    
    func setVisualAttributes() -> SelectRect {
        backgroundColor = UIColor.lightGrayColor().CGColor
        borderColor = UIColor.blackColor().CGColor
        borderWidth = 1
        opacity = 0.10
        return self
    }
}