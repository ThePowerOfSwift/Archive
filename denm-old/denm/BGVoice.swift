import UIKit
import QuartzCore

class BGVoice: CALayer {
    
    var bgVoiceSegments: [BGVoiceSegment] = []
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
}