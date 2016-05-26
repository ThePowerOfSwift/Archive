import UIKit
import QuartzCore

/**
Dynamic Marking Interpolation: Hairpin Linear Decrescendo
*/
class DMIHairpinLinearDecresc: DMIHairpinLinear {
    
    // MARK: Create a DMIHairpinLinearDecresc
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    override func setKerningKey() {
        kerningKey = ">"
    }
    

}