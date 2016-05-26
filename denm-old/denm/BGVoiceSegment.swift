import UIKit
import QuartzCore

class BGVoiceSegment: CALayer {
    
    var bgStrata: [BGStratum] = []
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
}