import UIKit
import QuartzCore

/**
Dynamic Marking Interpolation: Swell
*/
class DMISwellConcave: DMISwell {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    override func addComponents() -> DMInterpolation {
        // add shit here
        return self
    }
}