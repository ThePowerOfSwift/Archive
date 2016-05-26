import QuartzCore
import UIKit

/**
TBLigature (Tuplet Bracket Ligature)
*/
class TBLigature: CALayer {
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    var height: CGFloat { get { return abs(beamEndY - bracketEndY) } }
    
    var pad: CGFloat { get { return 0.236 * g } }
    
    // MARK: Position
    
    /// x-value of TBLigature
    var x: CGFloat = 0
    
    var top: CGFloat { get { return beamEndY < bracketEndY ? beamEndY : bracketEndY } }
    
    /// y-value of beamEnd of TBLigature
    var beamEndY: CGFloat = 0
    
    /// y-value of bracketEnd of TBLigature
    var bracketEndY: CGFloat = 0
    
    /// Orientation of TBLigature
    var o: CGFloat = 1
    
    // MARK: Components
    
    /// Line of TBLigature
    var line: TBLLine = TBLLine()
    
    /// BeamEndOrnament of TBLigature
    var beamEndOrnament: TBLOrnament?
    
    /// BracketEndOrnament of TBLigature
    var bracketEndOrnament: TBLOrnament?
    
    // MARK: Visual Attributes
    
    /// Color of TBLigature
    var color: CGColor = UIColor.lightGrayColor().CGColor
    
    // MARK: Create a TBLigature
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a TBLigature
    
    func setSize(#g: CGFloat) -> TBLigature {
        self.g = g
        return self
    }
    
    func setX(x: CGFloat) -> TBLigature {
        self.x = x
        return self
    }
    
    /**
    Set y-value of beamEnd of TBLigature
    
    :param: beamEndY y-value of beamEnd of TBLigature
    
    :returns: Self: TBLigature
    */
    func setBeamEndY(beamEndY: CGFloat) -> TBLigature {
        self.beamEndY = beamEndY
        return self
    }
    
    /**
    Set y-value of bracketEnd of TBLigature
    
    :param: bracketEndY y-value of bracketEnd of TBLigature
    
    :returns: Self: TBLigature
    */
    func setBracketEndY(bracketEndY: CGFloat) -> TBLigature {
        self.bracketEndY = bracketEndY
        return self
    }
    
    func setOrientation(orientation: CGFloat) -> TBLigature {
        self.o = orientation
        return self
    }
    
    func setColor(color: CGColor) -> TBLigature {
        self.color = color
        return self
    }
    
    /**
    Add all necessary components to TBLigature layer (override in each subclass)
    
    :returns: Self: TBLigature
    */
    func build() -> TBLigature {
        setFrame()
        addComponents()
        return self
    }
    
    func addComponents() {
        addLine()
        addCircle()
        addArrow()
    }
    
    func addLine() {
        line.setSize(g: g)
            .setX(0)
            .setTop(0)
            .setBottom(frame.height)
            .build()
        addSublayer(line)
    }
    
    func addCircle() {
        let circle: TBLOCircle = TBLOCircle()!
            .setSize(g: g)
            .setX(0)
            .setY(0)
            .build()
        addSublayer(circle)
        bracketEndOrnament = circle
    }
    
    func addArrow() {
        let arrow: TBLOArrow = TBLOArrow()!
            .setSize(g: g)
            .setX(0)
            .setTipY(frame.height)
            .setOrientation(-1)
            .build()
        addSublayer(arrow)
        beamEndOrnament = arrow
    }
    
    /**
    Add TBLOrnament (Tuplet Bracket Ligature Ornament) to beamEnd of TBLigature
    
    :param: ornamentType Type of TBLOrnament
    
    :returns: Self: TBLigature
    */
    func addBeamEndOrnament(ornamentType: String) -> TBLigature {
        beamEndOrnament = CreateTBLOrnament().withID(ornamentType)!
        return self
    }
    
    /**
    Add TBLOrnament (Tuplet Bracket Ligature Ornament) to bracketEnd of TBLigature
    
    :param: ornamentType Type of TBLOrnament
    
    :returns: Self: TBLigature
    */
    func addBracketEndOrnament(ornamentType: String) -> TBLigature {
        bracketEndOrnament = CreateTBLOrnament().withID(ornamentType)!

        return self
    }
    
    func resize() {
        setFrame()
        
        // investigate this for orientation == -1 :/
        line.setTop(0).setBottom(height).resize()
        if beamEndOrnament != nil {
            beamEndOrnament!.position.y = frame.height - 0.5 * beamEndOrnament!.frame.height
        }
        
    }
    
    func setFrame() {
        frame = CGRectMake(x, top, 0, height)
    }
    
    func getTopAndBottomFromBeamEndAndBracketEnd() -> (CGFloat, CGFloat) {
        println("getTopAndBottom")
        return beamEndY < bracketEndY ? (beamEndY, bracketEndY) : (bracketEndY, beamEndY)
    }
}