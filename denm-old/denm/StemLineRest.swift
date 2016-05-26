import QuartzCore

class StemLineRest: StemLine {
    
    var dashWidth: CGFloat = 4
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    func setDashWidth(dashWidth: CGFloat) -> StemLineRest {
        self.dashWidth = dashWidth
        return self
    }
    
    // add stroke dashes
    override func build() -> StemLineRest {
        makePath()
        lineDashPattern = [dashWidth]
        return self
    }
}