import UIKit
import QuartzCore

/**
BGContainer (Beam Group Container)
*/
class BGContainer: CALayer {
    
    // MARK: Model Context
    
    var spanContainer: SpanNode?
    
    var offsetDuration: Duration = Duration()
    
    // MARK: View Context
    
    /// BeamGroup that contains BGContainer
    var beamGroup: BeamGroup?
    
    /// Ordered collection of BGContainers contained by BGContainer (there may be 0-n.)
    var bgContainers: [BGContainer] = []
    
    var bgContainerCount: Int = 0 // ew
    
    /// Ordered collection of BGLeaves contained by BGContainer (there may be 1-n.)
    var leaves: [BGLeaf] = []
    
    /// Levels embedded in tuplet
    var depth: Int = 0
    
    // MARK: Size
    
   	/// Graphical height of a single Guidonian staff space
   	var g: CGFloat = 0
    
   	/// Graphical width of a single 8th-note
   	var beatWidth: CGFloat = 0
    
   	/// Graphical width of BGContainer
   	var width: CGFloat = 0
    
    /// Graphical height of BGContainer (set by height of beams)
    var height: CGFloat = 0
    
    // MARK: Position
    
    /// Graphical left of BGContainer (in context of BeamGroup)
    var left: CGFloat = 0
    
    /**
    Orientation of BGContainer
    
    - +1: Stems-down
    - -1: Stems-up
    - +0: Neutral
    */
    var o: CGFloat = 1 // orientation
    
    // MARK: Component Layers
    
    /// Layer containing beams
    let beams = BeamsLayer()!
    
    /// Layer containing stems
    let stems = StemsLayer()!
    
    /// Layer containing TBLigatures (Tuplet Bracket Ligatures)
    let ligatures = TBLigaturesLayer()
    
    /// Layer containing TupletBracket
    let tupletBracket = TupletBracket()
    
    /// Layer container MetronomeGraphics
    let mgGroup: MGGroup = MGGroup()
    
    // Temporal Settings ======================================================================
    var isNumerical: Bool = true
    var isMetrical: Bool = true
    
    // MARK: Manage TupletBracket and MGGroup
    
    /// If BGContainer includes TupletBracket
    var includesTupletBracket: Bool = true // default to true, need way of remembering
    
    /// If BGContainer includes MGGroup (Metronome Graphic Group)
    var includesMGGroup: Bool = false
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }

    // MARK: Incrementally build a BGContainer
    
    /**
    Set BeamGroup that containes BGContainer
    
    :param: beamGroup BeamGroup
    
    :returns: Self: BGContainer
    */
    func setBeamGroup(beamGroup: BeamGroup) -> BGContainer {
        self.beamGroup = beamGroup
        return self
    }
    
    /**
    Set SpanNode (containing child nodes)
    
    :param: spanContainer SpanNode
    
    :returns: Self: BGContainer
    */
    func setSpanContainer(spanContainer: SpanNode) -> BGContainer {
        self.spanContainer = spanContainer
        return self
    }
    
    /**
    Set offsetDuration of BGContainer
    
    :param: offsetDuration offsetDuration of BGContainer
    
    :returns: Self: BGContainer
    */
    func setOffsetDuration(offsetDuration: Duration) -> BGContainer {
        self.offsetDuration = offsetDuration
        return self
    }
    
    /**
    Set size of BGContainer
    
    :param: g         Graphical height of a single Guidonian staff space
    :param: beatWidth Graphical width of a single 8th-note
    
    :returns: Self: BGContainer
    */
    func setSize(g: CGFloat, beatWidth: CGFloat) -> BGContainer {
        self.g = g
        self.beatWidth = beatWidth
        self.width = spanContainer!.getWidth(beatWidth)
        beams.setSize(g: g, width: width, beatWidth: beatWidth)
        stems.setSize(g: g, width: width)
        return self
    }
    
    /**
    Set graphical position of BGContainer
    
    :param: left        Graphical left of BGContainer (in context of BeamGroup)
    :param: orientation Stems-up / Stems-down / neutral
    
    :returns: Self: BGContainer
    */
    func setPosition(left: CGFloat, orientation: CGFloat) -> BGContainer {
        self.left = left
        self.o = orientation
        return self
    }
    
    /**
    Set depth of BGContainer
    
    :param: depth Level embedded in tuplet
    
    :returns: Self: BGContainer
    */
    func setDepth(depth: Int) -> BGContainer {
        self.depth = depth
        return self
    }
    
    /**
    Add BGLeaf (Beam Group Leaf) to BGContainer
    
    :param: leaf Holds references to BeamGroups and GraphEvents
    
    :returns: Self: BGContainer
    */
    func addLeaf(leaf: BGLeaf) -> BGContainer {
        leaves.append(leaf)
        return self
    }
    
    /**
    Add BGContainer (Beam Group Container) to BGContainer
    
    :param: bgContainer BGContainer
    
    :returns: Self: BGContainer
    */
    func addContainer(bgContainer: BGContainer) -> BGContainer {
        bgContainers.append(bgContainer)
        return self
    }
    
    /**
    Set if BGContainer includes TupletBracket in View Context
    
    :param: includesTupletBracket Bool
    
    :returns: Self: BGContainer
    */
    func setIncludesTupletBracket(includesTupletBracket: Bool) -> BGContainer {
        self.includesTupletBracket = includesTupletBracket
        return self
    }
    
    /**
    Set if BGContainer include MGGroup (Metronome Graphic Group) in View Context
    
    :param: includesMGGroup Bool
    
    :returns: Self: BGContainer
    */
    func setIncludesMGGroup(includesMGGroup: Bool) -> BGContainer {
        if includesMGGroup && !(mgGroup.isIncluded) {
            mgGroup.setIsIncluded(true)
            addSublayer(mgGroup)
        }
        else if !includesMGGroup && mgGroup.isIncluded {
            mgGroup.setIsIncluded(false)
            mgGroup.removeFromSuperlayer()
        }
        return self
    }
    
    // MARK: User Interface
    
    func play() {
        beamGroup!.play()
    }
    
    func highlightMGGroup() {
        mgGroup.highlightWithBeatDuration(1)
    
        for bgContainer in bgContainers {
            let scale = spanContainer!.children![0].getInheritedScale()
            let offset: Double = bgContainer.offsetDuration.getTemporalLength(1) * Double(scale)
            var timer: NSTimer = NSTimer()
            timer = NSTimer.scheduledTimerWithTimeInterval(offset,
                target: self,
                selector: Selector("highlightNextChildContainer"),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    func highlightNextChildContainer() {
        if bgContainerCount >= bgContainers.count { bgContainerCount = 0 }
        bgContainers[bgContainerCount].highlightMGGroup()
        bgContainerCount++
    }
    
    /**
    Adds all necessary components
    
    :returns: Self: BGContainer
    */
    func build() -> BGContainer {
        addBeams()
        

        
        setFrame()
        
        addAugmentationDotsIfNecessary()
        
        createTupletBracket()
        createMGGroup()
        addLigatures()
        setBGContainerOffsetDurations()
        return self
    }
    
    func addAugmentationDotsIfNecessary() {
        
        println("addAugmentationDotsIfNecessary")
        
        for bgLeaf in leaves {
            if bgLeaf.amountAugmentationDots > 0 {
                let x: CGFloat = bgLeaf.xInContainer + 0.5 * g
                let amount: Int = bgLeaf.amountAugmentationDots
                
                println("add \(amount) aug dots")
                
                beams.addAugmentationDots(x: x, amount: amount, atDepth: depth)
            }
        }
    }
    
    func addLigatures() {

        ligatures.setBGContainer(self)
            .setSize(g: g)
            .setTop(tupletBracket.frame.maxY)
            .setWidth(width)
            .setFrame()
        
        var accumX: CGFloat = 0
        // this shall be conditional for if container != tree.maxHeight - 1
        if true {
            for n in 0..<spanContainer!.children!.count {
                let node = spanContainer!.children![n]
                
                if n == 0 {
                    if !node.isContainer { ligatures.addLigatureWithID("start", x: accumX) }
                }
                else if n == spanContainer!.children!.count - 1 {
                    let prevNode = spanContainer!.children![n-1]
                    if !node.isContainer && prevNode.isContainer {
                        ligatures.addLigatureWithID("reintroduce", x: accumX)
                    }
                    // if !node.isContainer { ligatures.addLigatureWithID("end", x: width - 5) }
                }
                else {
                    let prevNode = spanContainer!.children![n-1]
                    if !node.isContainer && prevNode.isContainer {
                        ligatures.addLigatureWithID("reintroduce", x: accumX)
                    }
                }
                accumX += node.getWidth(beatWidth)
            }
            ligatures.build()
        }
    }
    
    func addBeams() {
        beams.setBGContainer(self)
            .setColor(getColorByDepth(depth))
            .build()
        beamGroup?.beamsLayerStratum.addBeamsLayer(beams)
        addSublayer(beams)
    }
    
    func createTupletBracket() {
        let tupletBracketHeight = 1.618 * g
        let (s,b,l) = spanContainer!.getTupletDisplayInfo()
        tupletBracket.setInfo(sum: s, beats: b, subdivisionLevel: l)
            .setBeamGroup(beamGroup!)
            .setContainer(self)
            .setDepth(depth)
            .setSize(tupletBracketHeight, width: width)
            .setOrientation(o)
            .build()
        beamGroup!.addTupletBracket(tupletBracket, depth: depth)
        addSublayer(tupletBracket)
    }
    
    func createMGGroup() {
        mgGroup.setBGContainer(self)
            .setSize(g: g)
            .setBeatWidth(beatWidth)
            .build()
    }
    
    func setFrame() {
        setHeight()
        frame = CGRectMake(left, 0, width, height)
    }
    
    func setHeight() {
        height = beams.frame.height
    }

    func setBGContainerOffsetDurations() {
        var containerCount: Int = 0
        var beats: Int = 0
        for n in 0..<spanContainer!.children!.count {
            let node = spanContainer!.children![n]
            
            if node.isContainer {
                let subd = node.duration.subdivision.value
                let offsetDuration = Duration(beats: Beats(beats), subdivision: Subdivision(subd))
                bgContainers[containerCount].setOffsetDuration(offsetDuration)
                containerCount++
            }
            beats += node.duration.beats.amount
        }
    }
}