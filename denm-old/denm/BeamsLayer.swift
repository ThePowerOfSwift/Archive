import QuartzCore
import UIKit

/**
BeamsLayer
*/
class BeamsLayer: Stratum {
    
    internal let componentTypes: [String] = ["start", "end", "beamlets", "extended"]
    
    // MARK: View Context
    
    /// BGContainer (Beam Group Container)
    var bgContainer: BGContainer?
    
    /// Collection of BeamPathPoints on each level of subdivision
    var beamPathPointsOnLevel = Dictionary<Int, [BeamPathPoints]>()
    
    /// All Beams in BeamsLayer
    var beams: [Beam] = []
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Graphical width of a single 8th-note
    var beatWidth: CGFloat = 0
    
    /// Width of Beams
    var beamWidth: CGFloat = 0 // 0.382 * scale // make didSet?
    
    /// Displacement of one beam to the next
    var beamΔY: CGFloat = 0 // 1.5 * beamWidth // make didSet?
    
    /// Length of beamlet
    var beamletLength: CGFloat = 0 // 0.5 * g // make didSet?
    
    // MARK: Visual Attributes
    
    /// Color of Beams
    var color: CGColor = UIColor.blackColor().CGColor
    
    var containerPad: CGFloat = 0
    
    // MARK: Position
    
    /**
    Orientation of BeamGroup
    
    - +1: Stems-down
    - -1: Stems-up
    - +0: Neutral
    */
    var o: CGFloat = 0
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a BeamsLayer
    
    /**
    Set BGContainer
    
    :param: bgContainer BGContainer
    
    :returns: Self: BeamsLayer
    */
    func setBGContainer(bgContainer: BGContainer) -> BeamsLayer {
        self.bgContainer = bgContainer
        return self
    }
    
    /**
    Set size with Graphical height of a single Guidonian staff space, width, and beatWidth
    
    :param: g         Graphical height of a single Guidonian staff space
    :param: width     Width of BeamsLayer
    :param: beatWidth Graphical width of a single 8th-note
    
    :returns: Self: BeamsLayer
    */
    func setSize(#g: CGFloat, width: CGFloat, beatWidth: CGFloat) -> BeamsLayer {
        self.g = g
        self.width = width
        self.beatWidth = beatWidth
        self.beamWidth = 0.382 * g
        self.beamΔY = 1.5 * beamWidth
        self.beamletLength = 0.5 * g
        self.containerPad = 0.236 * g
        return self
    }
    
    /**
    Set orientation
    
    :param: orientation Orientation of BeamsLayer
    
    :returns: Self: BeamsLayer
    */
    func setOrientation(orientation: CGFloat) -> BeamsLayer {
        self.o = orientation
        return self
    }
    
    /**
    Set color of Beams
    
    :param: color Color
    
    :returns: Self: BeamsLayer
    */
    func setColor(color: CGColor) -> BeamsLayer {
        self.color = color
        return self
    }
    
    // MARK: Beams
    
    /**
    Start beams on specified level of Subdivision
    
    :param: level Level of Subdivision
    :param: x     x-value
    */
    func startBeamsOn(level: Int, x: CGFloat) {
        var pathPoints = BeamPathPoints()
        pathPoints.start = x
        
        // ensure
        if beamPathPointsOnLevel[level] == nil {
            beamPathPointsOnLevel[level] = [pathPoints]
        } else { beamPathPointsOnLevel[level]!.append(pathPoints) }
        
    }
    
    /**
    End beams on specified level of Subdivision
    
    :param: level Level of Subdivision
    :param: x     x-value
    */
    func endBeamsOn(level: Int, x: CGFloat) {
        var beamLevel = beamPathPointsOnLevel[level]!
        var pathPoints: BeamPathPoints = beamLevel.last!
        pathPoints.end = x
        beamPathPointsOnLevel[level]!.removeLast()
        beamPathPointsOnLevel[level]!.append(pathPoints)
    }
    
    /**
    Add beamlet on level of Subdivision
    
    :param: level     Level of Subdivision
    :param: x         x-value
    :param: direction Direction of Beamlet (-1: left, +1: right)
    */
    func beamletsOn(level: Int, x: CGFloat, direction: Int) {
        var x0: CGFloat = x
        var x1: CGFloat = x + CGFloat(direction) * beamletLength
        var pathPoints = BeamPathPoints(start: x0, end: x1)
        
        // ensure
        if beamPathPointsOnLevel[level] == nil {
            beamPathPointsOnLevel[level] = [pathPoints]
        } else { beamPathPointsOnLevel[level]!.append(pathPoints) }
    }
    
    /**
    Add Beams on level range
    
    :param: x                      x-value
    :param: node                   SpanNode
    :param: componentsOnLevelRange Array with range of levels of Subdivision
    :param: direction              Duration of Beamlet
    */
    func addBeamPathPointsOnLevel(
        x: CGFloat,
        node: SpanNode,
        componentsOnLevelRange: [[Int]],
        direction: Int
    ) {
        for component in 0..<componentTypes.count {
            let type: String = componentTypes[component]
            let range: [Int] = componentsOnLevelRange[component]
            if range != [0,0] {
                for level in range[0]...range[1] {
                    switch type {
                    case "start": startBeamsOn(level, x: x)
                    case "end": endBeamsOn(level, x: x)
                    case "beamlets": beamletsOn(level, x: x, direction: direction)
                    case "extended":
                        let x = x + node.getWidth(beatWidth) - containerPad
                        endBeamsOn(level, x: x)
                    default: println("default")
                    }
                }
            }
        }
    }
    
    func addAugmentationDots(#x: CGFloat, amount: Int, atDepth depth: Int) {
        var x: CGFloat = x + 0.5 * g
        for _ in 0..<amount {
            let augDot: AugmentationDot = AugmentationDot()
                .setX(x)
                .setY(frame.maxY)
                .setWidth(0.5 * g)
                .setColor(getColorByDepth(depth))
                .build()
            addSublayer(augDot)
            x += 1.5 * augDot.width
        }
    }
    
    /**
    Add all necessary components to BeamsLayer
    */
    func build() {
        opaque = true
        drawBeams()
        setFrame()
    }
    
    override func moveTo(#x: CGFloat, y: CGFloat) {
        CATransaction.setAnimationDuration(0.125)
        CATransaction.setAnimationTimingFunction(
            CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        )
        position.y = y + 0.5 * frame.height
    }
    
    // MARK: Analysis
    
    /**
    Get height of beams at given level of Subdivision
    
    :param: subdivisionLevel Level of Subdivision
    
    :returns: Height of beams at given level of Subdivision
    */
    func getBeamHeightWithSubdivisionLevel(subdivisionLevel: Int) -> CGFloat {
        let level: CGFloat = CGFloat(subdivisionLevel)
        let height: CGFloat = (level + 1) * beamΔY
        return height
    }
    
    override func setFrame() {
        //height = CGPathGetBoundingBox(path).height
        height = getBeamsHeight()
        frame = CGRectMake(0, 0, width, height)
    }
    
    private func getBeamsHeight() -> CGFloat {
        var amountBeams = 0
        for (level, _) in beamPathPointsOnLevel {
            amountBeams = level > amountBeams ? level : amountBeams
        }
        return CGFloat(amountBeams) * beamWidth + CGFloat(amountBeams - 1) * beamΔY
    }

    private func drawBeams() {
        for (i, level) in beamPathPointsOnLevel {
            var top: CGFloat = 0
            var ΔY = CGFloat(i - 1) * o * beamΔY
            for pathPoint in level {
                var y = top + CGFloat(i - 1) * o * beamΔY
                let beam: Beam = Beam()
                    .setWidth(beamWidth)
                    .setTop(y)
                    .setStart(pathPoint.start)
                    .setEnd(pathPoint.end)
                    .setColor(color)
                    .build()
                beams.append(beam)
                addSublayer(beam)
            }
        }
    }    
}