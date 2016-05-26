import UIKit
import QuartzCore

/**
Dynamic Marking Interpolation: Hairpin Exponential Decrescendo
*/
class DMIHairpinExponentialDecresc: DMIHairpinExponential {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(layer: AnyObject) { super.init(layer: layer) }
    override init() { super.init() }
    
    override func setKerningKey() {
        kerningKey = ">"
    }
}