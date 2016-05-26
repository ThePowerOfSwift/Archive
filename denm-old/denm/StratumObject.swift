import QuartzCore
import UIKit

class StratumObject: CALayer {
    
    var externalPads: ExternalPads = ExternalPads()
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }

    func setFrame() { /* override */ }
    
    func setExternalPads() { /* override */ }
}