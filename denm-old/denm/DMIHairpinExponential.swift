import UIKit
import QuartzCore

/**
Dynamic Marking Interpolation: Hairpin Exponential (with user-defined exponent - default: 2)
*/
class DMIHairpinExponential: DMIHairpin {
    
    var exponent: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(layer: AnyObject) { super.init(layer: layer) }
    override init() { super.init() }
    
    func setExponent(exponent: CGFloat) -> DMIHairpinExponential {
        self.exponent = exponent
        return self
    }
    
    override func addHairpin() {
        // something with control points
    }
    
    override func setPoints() {
        // something with control points
    }
}