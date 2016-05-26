import QuartzCore
import UIKit

/**
MetronomeGraphic
*/
class MetronomeGraphic: CAShapeLayer, Highlight {
    
    // MARK: View Context
    
    /// MGGroup (Metronome Graphic Group) containing MetronomeGraphic
    var mgGroup: MGGroup?
    
    // MARK: Size
    
    /// Height of MetronomeGraphic
    var height: CGFloat = 0
    
    /// Width of MetronomeGraphic
    var width: CGFloat = 0
    
    // MARK: Position
    
    /// Horizontal center of MetronomeGraphic
    var x: CGFloat = 0
    
    /// Vertical center of MetronomeGraphic
    var y: CGFloat = 0
    
    // MARK: Visual Attributes
    
    /// Default color of MetronomeGraphic
    var color_default: CGColor = UIColor.lightGrayColor().CGColor
    
    /// Highlighted color of MetronomeGraphic
    var color_highlighted: CGColor = UIColor.blueColor().CGColor
    
    // prolly unnecessary
    var isHighlighted: Bool = false
    
    let line: UIBezierPath = UIBezierPath()
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) {super.init(coder: aDecoder) }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    override init!() { super.init() }
    
    // MARK: Incrementally build a MetronomeGraphic
    
    /**
    Set MGGroup (Metronome Graphic Group) of MetronomeGraphic
    
    :param: mgGroup MGGroup
    
    :returns: Self: MetronomeGraphic
    */
    func setMGGroup(mgGroup: MGGroup) -> MetronomeGraphic {
        self.mgGroup = mgGroup
        return self
    }
    
    /**
    Set size of MetronomeGraphic with Graphical height of a single Guidonian staff space
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: MetronomeGraphic
    */
    func setSize(#g: CGFloat) -> MetronomeGraphic {
        
        return self
    }
    
    /**
    Set position of MetronomeGraphic
    
    :param: x Horizontal center of MetronomeGraphic
    :param: y Vertical center of MetronomeGraphic
    
    :returns: Self: MetronomeGraphic
    */
    func setPosition(x: CGFloat, y: CGFloat) -> MetronomeGraphic {
        self.x = x
        self.y = y
        setFrame()
        return self
    }
    
    /**
    Set verical center of MetronomeGraphic
    
    :param: y Vertical center of MetronomeGraphic
    
    :returns: Self: MetronomeGraphic
    */
    func setAltitude(y: CGFloat) -> MetronomeGraphic {
        self.y = y
        return self
    }
    
    /**
    Set horizontal center of MetronomeGraphic
    
    :param: x Horizontal center of MetronomeGraphic
    
    :returns: Self: MetronomeGraphic
    */
    func setX(x: CGFloat) -> MetronomeGraphic {
        self.x = x
        return self
    }
    
    /**
    Add all necessary components to MetronomeGraphic layer
    
    :returns: Self: MetronomeGraphic
    */
    func build() -> MetronomeGraphic {
        
        return self
    }
    
    internal func setFrame() -> MetronomeGraphic {
        self.frame = CGRectMake(x - 0.5 * width, y - 0.5 * height, width, height)
        return self
    }
    
    func switchHighlightedState() {
        if isHighlighted { deHighlight() }
        else { highlight() }
    }
    
    func highlightForDuration(duration: Double) {
        CATransaction.setDisableActions(true)
        highlight()
        CATransaction.setDisableActions(false)
        var timer: NSTimer = NSTimer()
        timer =  NSTimer.scheduledTimerWithTimeInterval(duration,
            target: self,
            selector: Selector("deHighlight"),
            userInfo: nil,
            repeats: false
        )
    }
    
    // MARK: User Interface
    
    /**
    Highlight (change color?) of MetronomeGraphic
    */
    func highlight() {
        
    }
    
    func deHighlight() {
        
    }
}