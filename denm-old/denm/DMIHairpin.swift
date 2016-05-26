import UIKit
import QuartzCore

/**
Dynamic Marking Interpolation: Hairpin
*/
class DMIHairpin: DMInterpolation {
    
    var direction: String = ""
    
    var points: [CGPoint] = []
    
    // MARK: Create a DMIHairpin
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(layer: AnyObject) { super.init(layer: layer) }
    override init() { super.init() }
    
    func setDirection(direction: String) -> DMInterpolation {
        self.direction = direction
        return self
    }
    
    func addHairpin() {

        
    }
    
    func setPoints() {
        if direction == "cresc" { cresc() }
        else { decresc() }
    }
    
    func cresc() -> DMIHairpin {

        return self
    }
    
    func decresc() -> DMIHairpin {

        
        return self
    }
}