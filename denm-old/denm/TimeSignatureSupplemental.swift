import UIKit
import QuartzCore

class TimeSignatureSupplemental: TimeSignature {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init(); opacity = 0.5 }
    override init!(layer: AnyObject) { super.init(layer: layer) }
}