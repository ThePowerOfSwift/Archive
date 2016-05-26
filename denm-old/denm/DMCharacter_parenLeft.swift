import UIKit
import QuartzCore

class DMCharacter_parenLeft: DMCharacter {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func setKerningKey() {
        kerningKey = "("
    }
}