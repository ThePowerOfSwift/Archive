import UIKit

class TBLReintroduceTruncated: TBLReintroduce {
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addComponents() {
        addLine()
        line.lineDashPattern = [0.236 * g]
        //addBracketEndLine()
        addBeamEndArrow()
    }
    
    func addBracketEndLine() {
        let line: TBLOLine = TBLOLine()
            .setSize(g: g)
            .setX(0)
            .setY(0)
            .build()
        addSublayer(line)
        bracketEndOrnament = line
    }
}