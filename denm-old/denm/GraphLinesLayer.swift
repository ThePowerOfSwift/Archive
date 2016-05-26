import QuartzCore
import UIKit

/**
GraphLinesLayer
*/
class GraphLinesLayer: CALayer {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a GraphLinesLayer
    
    /**
    Start GraphLines at desired x-value
    
    :param: x x-value
    
    :returns: Self: GraphLinesLayer
    */
    func startLinesAt(#x: CGFloat) -> GraphLinesLayer {
        /* override in each subclass */
        return self
    }
    
    /**
    Stop GraphLines at desired x-value
    
    :param: x x-value
    
    :returns: Self: GraphLinesLayer
    */
    func stopLinesAt(#x: CGFloat) -> GraphLinesLayer {
        /* override in each subclass */
        return self
    }
    
    /**
    Add all necessary components to GraphLinesLayer
    
    :returns: Self: GraphLinesLayer
    */
    func build() -> GraphLinesLayer {
        /* override in each subclass */
        return self
    }
    
    override func hitTest(p: CGPoint) -> CALayer! {
        if containsPoint(p) { return superlayer! }
        else { return nil }
    }
    
    override func containsPoint(p: CGPoint) -> Bool {
        return CGRectContainsPoint(frame, p)
    }
}