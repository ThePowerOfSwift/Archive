import QuartzCore
import UIKit

/**
TupletBracket
*/
class TupletBracket: StratumObject {
    
    // MARK: View Context
    
    /// BeamGroup to which TupletBracket belongs
    var beamGroup: BeamGroup?
    
    /// BGContainer (Beam Group Container) to which TupletBracket belongs
    var container: BGContainer?
    
    // MARK: Attributes
    
    /// Sum of amount of Beats of children
    var sum: Int = 0
    
    /// Amount of Beats in Duration
    var beats: Int = 0
    
    /// Level of Subdivision (amount of beams ==> 1: 8th-note, 2: 16th-note, 3: 32nd-note, etc)
    var subdivisionLevel: Int = 0
    
    /// Levels embedded in tuplet
    var depth: Int = 0
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Width of TupletBracket layer
    var width: CGFloat = 0
    
    /// Height of TupletBracket layer
    var height: CGFloat = 0
    
    /// Height of bracket: make a getter
    var bracketHeight: CGFloat = 0
    
    // MARK: Position
    
    /// Left of TupletBracket
    var left: CGFloat = 0
    
    /// Top of TupletBracket
    var top: CGFloat = 0
    
    /**
    Orientation of TupletBracket
    
    - +1: Stems-down
    - -1: Stems-up
    - +0: Neutral
    */
    var o: CGFloat = 0
    
    /// Center of TupletBracket
    var center: CGFloat = 0
    
    /// Amount of distance between bracket and center on left (making room for text)
    var centerPadLeft: CGFloat = 0
    
    /// Amount of distance between bracket and center on right (making room for text)
    var centerPadRight: CGFloat = 0
    
    /// Amount of space between right edge of bracket and absolute width of TupletBracket
    var rightPad: CGFloat = 0
    
    /// Amount of displacement of top of bracket to create slanted right edge
    var rightTopDisplace: CGFloat = 0
    
    /// Generic pad amount between components (text, subdivision graphic, etc)
    var padX: CGFloat = 0
    
    // MARK: Components
    
    /// Bracket Arms
    var arms = CAShapeLayer()
    
    /// Text for Sum of amount of Beats of children
    var textLeft = TextLayerByHeight()
    
    /// Text for amount of Beats in Duration
    var textRight = TextLayerByHeight()
    
    /// Subdivision Graphic
    var subdivisionGraphic = SubdivisionGraphic()
    
    // MARK: User Interface
    
    /// Amount of times TupletBracket has been tapped
    var taps: Int = 0
    
    // MARK: Create a TupletBracket
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a TupletBracket
    
    /**
    Set BeamGroup
    
    :param: beamGroup BeamGroup
    
    :returns: Self: TupletBracket
    */
    func setBeamGroup(beamGroup: BeamGroup) -> TupletBracket {
        self.beamGroup = beamGroup
        return self
    }
    
    /**
    Set BGContainer
    
    :param: container BGContainer
    
    :returns: Self: TupletBracket
    */
    func setContainer(container: BGContainer) -> TupletBracket {
        self.container = container
        return self
    }
    
    /**
    Set info for text and Subdivision Graphic
    
    :param: sum              Sum of amount of Beats of children
    :param: beats            Amount of Beats in Duration
    :param: subdivisionLevel Level of Subdivision in Duration
    
    :returns: Self: TupletBracket
    */
    func setInfo(#sum: Int, beats: Int, subdivisionLevel: Int) -> TupletBracket {
        self.sum = sum
        self.beats = beats
        self.subdivisionLevel = subdivisionLevel
        return self
    }
    
    /**
    Set depth of TupletBracket
    
    :param: depth Levels embedded in tuplet
    
    :returns: Self: TupletBracket
    */
    func setDepth(depth: Int) -> TupletBracket {
        self.depth = depth
        return self
    }
    
    /**
    Set width of TupletBracket
    
    :param: width Width of TupletBracket layer
    
    :returns: Self: TupletBracket
    */
    func setWidth(width: CGFloat) -> TupletBracket {
        self.width = width
        self.center = 0.5 * width
        return self
    }
    
    /**
    Set height
    
    :param: height Height of TupletBracket
    
    :returns: Self: TupletBracket
    */
    func setHeight(height: CGFloat) -> TupletBracket {
        self.height = height
        self.bracketHeight = 0.5 * height
        self.padX  = 0.5 * bracketHeight
        self.rightPad = 0.75 * bracketHeight
        self.rightTopDisplace = 0.618 * padX
        return self
    }
    
    /**
    Set size
    
    :param: height Height of TupletBracket layer
    :param: width  Width of TupletBracket layer
    
    :returns: Self: TupletBracket
    */
    func setSize(height: CGFloat, width: CGFloat) -> TupletBracket {
        self.height = height
        self.bracketHeight = 0.5 * height
        self.width = width
        self.center = 0.5 * width
        self.padX  = 0.5 * bracketHeight
        self.rightPad = 0.75 * bracketHeight
        self.rightTopDisplace = 0.75 * padX
        return self
    }
    
    /**
    Set top of TupletBracket layer
    
    :param: top Top of TupletBracket layer
    
    :returns: Self: TupletBracket
    */
    func setTop(top: CGFloat) -> TupletBracket {
        self.top = top
        return self
    }
    
    /**
    Set left of TupletBracket layer
    
    :param: left Left of TupletBracket layer
    
    :returns: Self: TupletBracket
    */
    func setLeft(left: CGFloat) -> TupletBracket {
        self.left = left
        return self
    }
    
    /**
    Set orientation of TupletBracket
    
    :param: orientation Orientation of TupletBracket
    
    :returns: Self: TupletBracket
    */
    func setOrientation(orientation: CGFloat) -> TupletBracket {
        self.o = orientation
        return self
    }
    
    /**
    Add all necessary components to TupletBracket layer
    
    :returns: Self: TupletBracket
    */
    func build() -> TupletBracket {
        opaque = true
        setFrame()
        addObjects()
        return self
    }
    
    // MARK: User Interface
    
    /**
    Tap the TupletBracket
    */
    func tap() {
        taps++
        beamGroup?.bgStratum?.mgCompoundStratumAtDepth[depth]?.switchIncludedState()
    }
    
    /**
    Reduces hitTest scope to TupletBracket
    
    :param: p touched point
    
    :returns: Self: as CALayer
    */
    override func hitTest(p: CGPoint) -> CALayer! {
        if containsPoint(p) { return self }
        return nil
    }
    
    /**
    Reduces hitTest scope to TupletBracket
    
    :param: p touched point
    
    :returns: Bool
    */
    override func containsPoint(p: CGPoint) -> Bool {
        return CGRectContainsPoint(frame, p)
    }
    
    private func addObjects() {
        centerPadLeft = 0
        centerPadRight = 0
        addSubdivisionGraphic()
        centerPadLeft += 0.5 * subdivisionGraphic.width + padX
        centerPadRight += 0.5 * subdivisionGraphic.width + padX
        addText()
        centerPadLeft += textLeft.frameWidth + padX
        centerPadRight += textRight.frameWidth + padX
        addArms()
    }
    
    private func addSubdivisionGraphic() {
        subdivisionGraphic.setInfo(subdivisionLevel)
            .setSize(height)
            .setPosition(0.5 * width, centerY: 0.5 * height)
            .setOrientation(o)
            .build()
        self.addSublayer(subdivisionGraphic)
    }
    
    private func addText() {
        let textHeight: CGFloat = 0.75 * height
        let textTop: CGFloat = 0.5 * (height - textHeight)
        let textFont: String = "AvenirNextCondensed-Regular"
        
        // text left
        textLeft.setInfo("\(sum)")
        textLeft.setSize(textHeight, fontName: textFont, alignmentMode: kCAAlignmentRight)
        textLeft.setPosition(center - centerPadLeft, top: textTop)
        self.addSublayer(textLeft)
        
        // text right
        textRight.setInfo("\(beats)")
        textRight.setSize(textHeight, fontName: textFont, alignmentMode: kCAAlignmentLeft)
        textRight.setPosition(center + centerPadRight, top: textTop)
        self.addSublayer(textRight)
    }
    
    private func addArms() {
        let top: CGFloat = o > 0 ? height : 0
        let path: UIBezierPath = UIBezierPath()
        // left arm
        path.moveToPoint(CGPointMake(0, top))
        path.addLineToPoint(CGPointMake(0, 0.5 * height))
        path.addLineToPoint(CGPointMake(center - centerPadLeft, 0.5 * height))
        // right arm
        if (width - rightPad - rightTopDisplace) > (center + centerPadRight) {
            path.moveToPoint(CGPointMake(center + centerPadRight, 0.5 * height))
            path.addLineToPoint(CGPointMake(width - rightPad - rightTopDisplace, 0.5 * height))
            path.addLineToPoint(CGPointMake(width - rightPad, top))
        }
        arms.path = path.CGPath
        //arms.frame = CGRectMake(0, top, width, bracketHeight)
        arms.lineWidth = 0.08375 * bracketHeight
        arms.strokeColor = UIColor.lightGrayColor().CGColor
        arms.fillColor = UIColor.clearColor().CGColor
        self.addSublayer(arms)
    }

    override func setFrame() {
        setExternalPads()
        frame = CGRectMake(left, top, width, height)
    }
    
    override func setExternalPads() {
        externalPads.setBottom(0.618 * height)
    }
    
    
    func highlight() {
        CATransaction.setDisableActions(true)
        arms.strokeColor = UIColor.redColor().CGColor
        CATransaction.setDisableActions(false)
    }
    

}