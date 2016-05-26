import QuartzCore
import UIKit

/**
MGGroup (Metronome Graphic Group)
*/
class MGGroup: Stratum {
    
    // MARK: Model Context
    
    /// MetronomeSpanTree of MGGroup
    var metronomeSpanTree: MetronomeSpanTree?
    
    // MARK: View Context
    
    /// BGContainer (Beam Group Container) of MGGroup
    var bgContainer: BGContainer?
    
    /// MGStratum (Metronome Graphic Container) of MGGroup
    var mgStratum: MGStratum?
    
    /// Collection of MGSubgroups (Metronome Graphic Subgroups) in MGGroup
    var mgSubgroups: [MGSubgroup] = []
    
    // this will become obsolete...
    /// Collection of MetronomeGraphics in MGGroup
    var metronomeGraphics: [MetronomeGraphic] = []
    
    // ligature...: may be multiple ligatures, based on depth
    
    // Info ===================================================================================
    var isIncluded: Bool = false
    var depth: Int = 0
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Graphical width of a single 8th-note
    var beatWidth: CGFloat = 0
    
    // MARK: Position
    
    /// Vertical center of MGGroup
    var altitude: CGFloat = 0
    
    // MARK: User Interface
    
    var timer: NSTimer = NSTimer()
    var loopCount: Int = 0
    var progressBar: CAShapeLayer = CAShapeLayer()
    
    var ligature = MGLigature()
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) {super.init(coder: aDecoder) }
    override init(layer: AnyObject) { super.init(layer: layer) }
    override init() { super.init() }
    
    // MARK: Incrementally build a MGGroup
    
    /**
    Set MetronomeSpanTree of MGGroup
    
    :param: metronomeSpanTree MetronomeSpanTree
    
    :returns: Self: MGGroup
    */
    func setMetronomeSpanTree(metronomeSpanTree: MetronomeSpanTree) -> MGGroup {
        self.metronomeSpanTree = metronomeSpanTree
        return self
    }
    
    /**
    Set BGContainer (Beam Group Container) of MGGroup
    
    :param: bgContainer BGContainer
    
    :returns: Self: MGGroup
    */
    func setBGContainer(bgContainer: BGContainer) -> MGGroup {
        self.bgContainer = bgContainer
        return self
    }
    
    /**
    Set MGStratum (Metronome Group Stratum) of MGGroup
    
    :param: mgStratum MGStratum
    
    :returns: Self: MGGroup
    */
    func setMGStratum(mgStratum: MGStratum) -> MGGroup {
        self.mgStratum = mgStratum
        return self
    }
    
    
    /**
    Set depth of MGGroup
    
    :param: depth Levels embedded in tuplet
    
    :returns: Self: MGGroup
    */
    func setDepth(depth: Int) -> MGGroup {
        self.depth = depth
        return self
    }
    
    /**
    Set size with Graphical height of a single Guidonian staff space
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: MGGroup
    */
    func setSize(#g: CGFloat) -> MGGroup {
        self.g = g
        return self
    }
    
    /**
    Set Graphical width of a single 8th-note
    
    :param: beatWidth Graphical width of a single 8th-note
    
    :returns: Self: MGGroup
    */
    func setBeatWidth(beatWidth: CGFloat) -> MGGroup {
        self.beatWidth = beatWidth
        return self
    }
    
    /**
    Set height of MGGroup
    
    :param: height Height of MGGroup
    
    :returns: Self: MGGroup
    */
    func setHeight(height: CGFloat) -> MGGroup {
        self.height = height
        positionMetronomeGraphics()
        return self
    }
    
    /**
    Set vertical center of MGGroup
    
    :param: altitude Vertical center of MGGRoup
    
    :returns: Self: MGGroup
    */
    func setAltitude(altitude: CGFloat) -> MGGroup {
        self.altitude = altitude
        return self
    }
    
    /**
    Set left of MGGroup
    
    :param: left Left of MGGroup
    
    :returns: Self: MGGroup
    */
    func setLeft(left: CGFloat) -> MGGroup {
        self.left = left
        return self
    }
    
    /**
    Set top of MGGroup
    
    :param: top Top of MGGroup
    
    :returns: Self: MGGroup
    */
    func setTop(top: CGFloat) -> MGGroup {
        self.top = top
        return self
    }
    
    /**
    Set if MGGroup is included in View Context
    
    :param: isIncluded If MGGroup is included in View Context
    
    :returns: Self: MGGroup
    */
    func setIsIncluded(isIncluded: Bool) -> MGGroup {
        self.isIncluded = isIncluded
        return self
    }
    
    /**
    Add MetronomeGraphic with amount of beats, level of subdivision at x-value
    
    :param: beats            Amount of Beats
    :param: subdivisionLevel Level of Subdivision
    :param: x                x-value
    */
    func addMetronomeGraphicWithBeats(beats: Int, subdivisionLevel: Int, x: CGFloat) {
        let metronomeGraphic: MetronomeGraphic = CreateMetronomeGraphic()
            .withDuration(beats, subdivisionLevel: subdivisionLevel)!
            .setMGGroup(self)
            .setSize(g: g)
            .setX(x)
        metronomeGraphics.append(metronomeGraphic)
    }
    
    /**
    Add all necessary components to MGGroup layer
    
    :returns: Self: MGGroup
    */
    func build() -> MGGroup {
        opaque = true
        addMetronomeGraphicsWithMetronomeSpanTree()
        buildMetronomeGraphics()
        setHeightWithGreatestMetronomeGraphicHeight()
        setFrame()
        positionMetronomeGraphics()
        addTestLigature()
        addMetronomeGraphics()
        return self
    }
    
    // MARK: User Interface
    
    /**
    Highlight MGGroup
    */
    func highlight() {
        for metronomeGraphic in metronomeGraphics {
            metronomeGraphic.highlight()
        }
    }
    
    internal func addMetronomeGraphicsWithMetronomeSpanTree() -> MGGroup {
        setMetronomeSpanTree(bgContainer!.spanContainer!.metronomeSpanTree)
        let inheritedScale = CGFloat(metronomeSpanTree!.inheritedScale)
        let subdLevel: Int = metronomeSpanTree!.root.duration.subdivision.level
        let beatsSum: Int = getSum(metronomeSpanTree!.root.getBeatsList())
        var accumLeft: CGFloat = 0
        width = metronomeSpanTree!.root.getWidth(beatWidth) * inheritedScale
        
        // recurse to add MetronomeGraphics
        traverseToAddMetronomeGraphics(
            metronomeSpanTree!.root,
            accumLeft: &accumLeft,
            width: width,
            beatsSum: beatsSum
        )
        return self
    }
    
    internal func traverseToAddMetronomeGraphics(
        metronomeSpanNode: SpanNode,
        inout accumLeft: CGFloat,
        width: CGFloat,
        beatsSum: Int
    ) {
        for child in metronomeSpanNode.children! {
            if child.children != nil {
                traverseToAddMetronomeGraphics(
                    child,
                    accumLeft: &accumLeft,
                    width: width,
                    beatsSum: beatsSum
                )
            }
            else {
                let beats: Int = child.duration.beats.amount
                let subdLevel: Int = metronomeSpanNode.duration.subdivision.level
                addMetronomeGraphicWithBeats(beats, subdivisionLevel: subdLevel, x: accumLeft)
                let localWidth: CGFloat = width * (CGFloat(beats) / CGFloat(beatsSum))
                accumLeft += localWidth
            }
        }
    }
    
    // encapsulate
    func addTestLigature() {
        ligature = MGLigature()
            .setSize(g: g)
            .setLength(metronomeGraphics.last!.position.x)
        addSublayer(ligature)
    }
    
    internal func buildMetronomeGraphics() {
        for metronomeGraphic in metronomeGraphics { metronomeGraphic.build() }
    }
    
    internal func addMetronomeGraphics() {
        for metronomeGraphic in metronomeGraphics { addSublayer(metronomeGraphic) }
    }
    
    internal func positionMetronomeGraphics() {
        setFrame()
        for metronomeGraphic in metronomeGraphics {
            metronomeGraphic.setAltitude(0.5 * frame.height).setFrame()
        }
        ligature.setAltitude(0.5 * frame.height).build()
        
    }
    
    func getGreatestMetronomeGraphicHeight() -> CGFloat {
        var maxHeight: CGFloat = 0
        for metronomeGraphic in metronomeGraphics {
            if metronomeGraphic.height > maxHeight { maxHeight = metronomeGraphic.height }
        }
        return maxHeight
    }
    
    func setHeightWithGreatestMetronomeGraphicHeight() {
        height = getGreatestMetronomeGraphicHeight()
    }
    
    override func setFrame() {
        setWidth()
        frame = CGRectMake(left, top, width, height)
    }
    
    override func setWidth() -> MGGroup {
        if metronomeSpanTree != nil { width = metronomeSpanTree!.refNode.getWidth(beatWidth) }
        else { width = metronomeGraphics.last!.frame.maxX }
        return self
    }

    func highlightWithBeatDuration(beatDuration: Double) {
        var accumTime: Double = 0
        for i in 0..<metronomeSpanTree!.getLeaves().count {
            let leaf = metronomeSpanTree!.getLeaves()[i]
            let inheritedScale = bgContainer!.spanContainer!.children![0].getInheritedScale()
            let dur: Double = beatDuration * Double(inheritedScale) * 8.0 * (
                Double(leaf.duration.beats.amount) / Double(leaf.duration.subdivision.value)
            )
            var timer: NSTimer = NSTimer()
            timer = NSTimer.scheduledTimerWithTimeInterval(accumTime,
                target: self,
                selector: Selector("highlightNextMetronomeGraphic:"),
                userInfo: dur,
                repeats: false
            )
            accumTime += dur
        }
        animateProgressBar()
    }

    func animateProgressBar() {
        let progressBar: MGProgressBar = makeProgressBar()
        insertSublayer(progressBar, below: metronomeGraphics[0])
        let scale = Double(bgContainer!.spanContainer!.getInheritedScale())
        let dur = metronomeSpanTree!.root.duration.getTemporalLength(1) * scale
        progressBar.animateWithDuration(dur)
    }
    
    func highlightNextMetronomeGraphicWithDuration(duration: Double) {
        if loopCount >= metronomeGraphics.count { loopCount = 0 }
        metronomeGraphics[loopCount].highlightForDuration(duration)
        loopCount++
    }
    
    
    func highlightNextMetronomeGraphic(timer: NSTimer) {
        if let dur = timer.userInfo! as? Double {
            if loopCount >= metronomeGraphics.count { loopCount = 0 }
            metronomeGraphics[loopCount].highlightForDuration(dur)
            loopCount++
        }
    }
    
    internal func makeProgressBar() -> MGProgressBar {
        let progressBar: MGProgressBar = MGProgressBar()
            .setSize(g: g)
            .setLength(width)
            .setAltitude(0.5 * frame.height)
            .build()
        return progressBar
    }
}

