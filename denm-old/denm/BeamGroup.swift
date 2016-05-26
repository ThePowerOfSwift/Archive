import QuartzCore
import UIKit

/**
Visual representation of rhythm, with capacity for arbitrarily deep nested tuplets
*/
class BeamGroup: StratumContainer {
    
    // MARK: Model Context
    
    /// The SpanTree containing rhythm and musical information
    var spanTree: SpanTree?
    
    // MARK: View Context

    /// The System containing BeamGroup
    var system: System?
    
    /// The BGStratum containing BeamGroup
    var bgStratum: BGStratum?
    
    var isNumerical: Bool = true // create documentation for this
    var isMetrical: Bool = true // ...
    
    // MARK: Size
    
	/// Graphical height of a single Guidonian staff space
	var g: CGFloat = 0
    
	/// Graphical width of a single 8th-note
	var beatWidth: CGFloat = 0

	// MARK: Position
    
    /** 
    Orientation of BeamGroup
    
    - +1: Stems-down
    - -1: Stems-up
    - +0: Neutral
    */
    var o: CGFloat = 1

    // MARK: Containers and Leaves
    
    /// Ordered collection of all BGContainers in BeamGroup
    var containers: [BGContainer] = []
    
    /// Ordered collection of all BGLeaves in BeamGroup
    var leaves: [BGLeaf] = []
    
    // MARK: Sublayers
    
    // DEStratum
    
    /// Contains references to all BeamsLayers of all depth-levels
    var beamsLayerStratum: BeamsLayerStratum = BeamsLayerStratum()
    
    /// Contains reference to all Tuplet Brackets at specified depth
    var tbStratumAtDepth = Dictionary<Int, TBStratum>()
    
    /// Contains reference to all MGGroups (Metronome Graphic Groups) at specified depth
    var mgStratumAtDepth = Dictionary<Int, MGStratum>()
    
    // MARK: Create a BeamGroup
    
    /**
    Create BeamGroup with SpanTree: more discussion needed
    
    :param: spanTree SpanTree
    
    :returns: Self: BeamGroup
    */
    init(spanTree: SpanTree) { self.spanTree = spanTree; super.init() }
    override init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }

    // MARK: Incrementally build a BeamGroup
    
    /**
    Set SpanTree
    
    :param: spanTree Entire musical grouping, with rhythm and material
    
    :returns: Self: BeamGroup
    */
    func setSpanTree(spanTree: SpanTree) -> BeamGroup {
    	self.spanTree = spanTree
        return self
    }
    
    /**
    Set System that contains BeamGroup
    
    :param: system System
    
    :returns: Self: BeamGroup
    */
    func setSystem(system: System) -> BeamGroup {
        self.system = system
        return self
    }
    
    /**
    Set BGStratum (Beam Group Stratum)
    
    :param: bgStratum Collection of BeamGroups aligned horizontally
    
    :returns: Self: BeamGroup
    */
    func setBGStratum(bgStratum: BGStratum) -> BeamGroup {
        self.bgStratum = bgStratum
        return self
    }

    /**
    Set size of BeamGroup
    
    :param: g         Graphical height of a single Guidonian staff space
    :param: beatWidth Graphical width of a single 8th-note
    
    :returns: Self: BeamGroup
    */
    func setSize(#g: CGFloat, beatWidth: CGFloat) -> BeamGroup {
    	self.g = g
    	self.beatWidth = beatWidth
    	self.width = spanTree!.root.getWidth(beatWidth)
    	return self
    }
    
    /**
    Set top of BeamGroup
    
    :param: top Graphical top of BeamGroup layer
    
    :returns: Self: BeamGroup
    */
    func setTop(top: CGFloat) -> BeamGroup {
        self.top = top
        return self
    }
    
    /**
    Set left of BeamGroup
    
    :param: left Graphical left of BeamGroup layer
    
    :returns: Self: BeamGroup
    */
    func setLeft(left: CGFloat) -> BeamGroup {
        self.left = left
        return self
    }
    
    /**
    Orientation of BeamGroup
    
    - +1: Stems-down
    - -1: Stems-up
    - +0: Neutral
    */
    func setOrientation(orientation: CGFloat) -> BeamGroup {
        self.o = orientation
        self.beamsLayerStratum.setOrientation(o)
        return self
    }
    
    /**
    Add TupletBracket at specified depth
    
    :param: tupletBracket TupletBracket
    :param: depth         Levels embedded in tuplet
    */
    func addTupletBracket(tupletBracket: TupletBracket, depth: Int)  -> BeamGroup {
        ensureTBStratumAtDepth(depth)
        tbStratumAtDepth[depth]!.addTupletBracket(tupletBracket)
        return self
    }
    
    /**
    Add MGGroup (MetronomeGraphic Group) at the specified depth
    
    :param: mgGroup MGGroup (MetronomeGraphic Group)
    :param: depth   Levels embedded in tuplet
    */
    func addMGGroup(mgGroup: MGGroup, depth: Int) {
        ensureMGStratumAtDepth(depth)
        mgStratumAtDepth[depth]!.addMGGroup(mgGroup)
    }
    
    /**
    Add leaf
    
    :param: leaf BGLeaf
    */
    func addLeaf(leaf: BGLeaf) {
        leaves.append(leaf)
    }

    // MARK: Inclusion / Exclusion of TBStrata / MGStrata
    
    /**
    Add all TupletBrackets at specified depth to View Context
    
    :param: depth Levels embedded in tuplet
    
    :returns: Self: BeamGroup
    */
    func includeTBStratumAtDepth(depth: Int) -> BeamGroup {
        for container in containers {
            if container.depth == depth { container.setIncludesTupletBracket(true) }
        }
        return self
    }
    
    /**
    Remove all TupletBrackets at specified depth from View Context
    
    :param: depth Levels embedd in tuplet
    
    :returns: Self: BeamGroup
    */
    func excludeTBStratumAtDepth(depth: Int) -> BeamGroup {
        for container in containers {
            if container.depth == depth { container.setIncludesTupletBracket(false) }
        }
        return self
    }
    
    /**
    Add all MGGroups (MetronomeGraphic Group) at specified depth to View Context
    
    :param: depth Levels embedded in tuplet
    
    :returns: Self: BeamGroup
    */
    func includeMGStratumAtDepth(depth: Int) -> BeamGroup {
        for container in containers {
            if container.depth == depth { container.setIncludesMGGroup(true) }
        }
        return self
    }
    
    /**
    Remove all MGGroups (MetronomeGraphic Groups) from View Context at specified depth
    
    :param: depth Levels embedded in tuplet
    
    :returns: Self: BeamGroup
    */
    func excludeMGStratumAtDepth(depth: Int) -> BeamGroup {
        for container in containers {
            if container.depth == depth { container.setIncludesMGGroup(false) }
        }
        return self
    }
    
    /**
    Add all necessary components to View Context
    
    :returns: Self: BeamGroup
    */
    override func build() -> BeamGroup {
        
        // organize containers, leaves, and beams
        createContainersAndLeaves()
        addBeams()
        
        
        
        buildContainers()
        
        // orgranizeStrata()
        addTupletBracketStrataToStrata()
        addBeamsLayerStratumToStrata()
        
        // perhaps encapsulate
        adjustStratumOrderForOrientation()
        positionStrata()
        adjustBeamsLayerStratumYForOrientation()
        
        return self
    }
    
    // MARK: User Interface
    
    func play() {
        system!.play()
    }
    
    func highlightMGGroups() {
        containers[0].highlightMGGroup()
    }
    
    func ensureTBStratumAtDepth(depth: Int) {
        if tbStratumAtDepth[depth] == nil { tbStratumAtDepth[depth] = TBStratum()! }
    }
    
    func ensureMGStratumAtDepth(depth: Int) {
        if mgStratumAtDepth[depth] == nil { mgStratumAtDepth[depth] = MGStratum()! }
    }
    
    func colorTupletBracketRed(tupletBracket: TupletBracket) {
        tupletBracket.arms.strokeColor = UIColor.greenColor().CGColor
    }
    
    func addTupletBracketStrataToStrata() {
        for depth in 0...getGreatestTupletBracketDepth() {
            let tbStratum = tbStratumAtDepth[depth]!
            tbStratum.build()
            addStratum(tbStratum)
            mgStratumAtDepth[depth]!.setBeamGroup(self).setDepth(depth).build()
        }
    }
    
    func getGreatestTupletBracketDepth() -> Int {
        var maxDepth: Int = 0
        for (depth, stratum) in tbStratumAtDepth {
            if depth > maxDepth { maxDepth = depth }
        }
        return maxDepth
    }
    
    func adjustStratumOrderForOrientation() {
        if o < 0 { strata = strata.reverse() }
    }
    
    func adjustBeamsLayerStratumYForOrientation() {
        if o < 0 { beamsLayerStratum.moveTo(x: 0, y: beamsLayerStratum.height) }
    }
    
    func addBeamsLayerStratumToStrata() {
        beamsLayerStratum.build()
        addStratum(beamsLayerStratum)
    }

    func createContainersAndLeaves() {
        var xInContainer: CGFloat = 0.0
        var xInBeamGroup: CGFloat = 0.0
        spanTree!.clean()
        traverseToCreateContainersAndLeavesWithSpanNode(spanTree!.root,
            layerContext: self,
            xInContainer: &xInContainer,
            xInBeamGroup: &xInBeamGroup
        )
    }
    
    func traverseToCreateContainersAndLeavesWithSpanNode(
        node: SpanNode,
        layerContext: CALayer,
        inout xInContainer: CGFloat,
        inout xInBeamGroup: CGFloat
    ) {
        if node.isContainer {
            let container: BGContainer = makeBGContainerWithSpanNode(node, x: xInContainer)
                .setDepth(node.getDepth())
            commitBGContainer(container, context: layerContext)
            var _xInContainer: CGFloat = 0
            for child in node.children! {
                traverseToCreateContainersAndLeavesWithSpanNode(child,
                    layerContext: container,
                    xInContainer: &_xInContainer,
                    xInBeamGroup: &xInBeamGroup
                )
                adjustXInContainer(&_xInContainer, child: child)
            }
        }
        else {
            let bgContainer = layerContext as BGContainer
            let leaf: BGLeaf = BGLeaf()
                .setSpanLeaf(node)
                .setContainer(bgContainer)
                .setDepth(node.parent!.getDepth())
                .setSize(g: g)
                .setOrientation(o)
                .setXInContainer(xInContainer)
                .setXInBeamGroup(xInBeamGroup)
            addLeaf(leaf)
            bgContainer.addLeaf(leaf)
            xInBeamGroup += node.getWidth(beatWidth)
        }
    }
    
    func adjustXInContainer(inout _xInContainer: CGFloat, child: SpanNode) {
        if child !== child.parent!.children!.last! {
            _xInContainer += child.getWidth(beatWidth)
        } else { _xInContainer = 0 }
    }
    
    func commitBGContainer(container: BGContainer, context: CALayer) {
        containers.append(container)
        if let parentContainer = context as? BGContainer {
            parentContainer.addContainer(container)
        }
        context.addSublayer(container)
    }
    
    func makeBGContainerWithSpanNode(spanNode: SpanNode, x: CGFloat) -> BGContainer {
        var depth = spanNode.getDepth()
        let bgContainer: BGContainer = BGContainer()!
            .setBeamGroup(self)
            .setSpanContainer(spanNode)
            .setSize(g, beatWidth: beatWidth)
            .setPosition(x, orientation: o)
        ensureTBStratumAtDepth(depth)
        addTupletBracket(bgContainer.tupletBracket, depth: depth)
        addMGGroup(bgContainer.mgGroup, depth: depth)
        return bgContainer
    }

    func buildContainers() {
        for container in containers { container.build() }
    }
    
    func addBeams() {
        
        // switch, isMetrical: case: true; case: false
        
        for i in 0..<leaves.count {
            let leaf: BGLeaf = leaves[i]
            let junction: BeamJunction = CreateBeamJunction().withContext(i: i, array: leaves)!
            let junctionComponents = junction.getComponents()
            let direction = junction.beamletDirection!
            let bgContainer: BGContainer = leaf.bgContainer!
            bgContainer.beams
                .setSize(g: g, width: leaf.spanLeaf!.getWidth(beatWidth), beatWidth: beatWidth)
                .setOrientation(o)
                .addBeamPathPointsOnLevel(
                    leaf.xInContainer,
                    node: leaf.spanLeaf!,
                    componentsOnLevelRange: junctionComponents,
                    direction: direction
                )
        }
    }
    
    override func setFrame() {
        setExternalPads()
        frame = CGRectMake(left, top, width, height)
    }
    
    override func setExternalPads() {
        //externalPads.setBottom(1.236 * g)
    }
    
    func getColorByDepth(depth: Int) -> CGColor {
        let colorByDepth = [
            UIColor.lightGrayColor().CGColor,
            UIColor.orangeColor().CGColor,
            UIColor.greenColor().CGColor,
            UIColor.redColor().CGColor,
            UIColor.blueColor().CGColor
        ]
        return colorByDepth[depth]
    }
}