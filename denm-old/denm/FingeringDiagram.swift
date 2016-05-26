import QuartzCore
import UIKit

class FingeringDiagram: CALayer {
    
    var keys: [FDKey] = []
    
    // CALayer Init ===========================================================================
    override init() { super.init() }
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(layer: AnyObject!) { super.init(layer: layer) }
    
    func build() -> FingeringDiagram {
        
        return self
    }
}