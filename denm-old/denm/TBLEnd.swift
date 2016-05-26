import QuartzCore
import UIKit

/**
TBLEnd (Tuplet Bracket Ligature End)
*/
class TBLEnd: TBLigature {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addComponents() {
        addLine()
        addBracketEndArrow()
    }
    
    func addBracketEndArrow() {
        let arrow: TBLOArrow = TBLOArrow()!
            .setSize(g: g)
            .setX(0)
            .setTipY(0)
            .setOrientation(1)
            .build()
        addSublayer(arrow)
        bracketEndOrnament = arrow
    }
}