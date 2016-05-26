import QuartzCore

/**
GraphEvent
*/
class GraphEvent {
    
    // MARK: Position
    
    var x: CGFloat
    
    // MARK: Components
    
    /// Graph upon which GraphEvent occurs
    var graph: Graph?
    
    /// BGLeaf (Beam Group Leaf) linked to this GraphEvent
    var bgLeaf: BGLeaf?
    
    /// All iterms in GraphEvent
    var items: [CALayer] = []
    
    var articulations: [Articulation] = []
    
    // MARK: Analysis
    
    /// If GraphEvent is rest
    var isRest: Bool { get { return getIsRest() } }
    
    /// Maximum y-value of information within Graph layer
    var maxInfoY: CGFloat { get { return getMaxInfoY() } } // override?
    
    /// Minimum y-value of information within Graph layer
    var minInfoY: CGFloat { get { return getMinInfoY() } } // override?
    
    var startsSlur: Bool = false
    var endsSlur: Bool = false
    
    // MARK: Create a GraphEvent
    
    /**
    Create a GraphEvent at desired x-value
    
    :param: x horizontal position of GraphEvent on Graph
    
    :returns: Self: GraphEvent
    */
    init(x: CGFloat) {
        self.x = x
    }
    
    // MARK: Incrementally build a GraphEvent
    
    /**
    Set BGLeaf (Beam Group Leaf)
    
    :param: bgLeaf BGLeaf
    
    :returns: Self: GraphEvent
    */
    func setBGLeaf(bgLeaf: BGLeaf) -> GraphEvent {
        self.bgLeaf = bgLeaf
        return self
    }
    
    /**
    Set Graph
    
    :param: graph Graph
    
    :returns: Self: GraphEvent
    */
    func setGraph(graph: Graph) -> GraphEvent {
        self.graph = graph
        return self
    }
    
    /**
    Add Item to GraphEvent
    
    :param: item Any type of musical information
    
    :returns: Self: GraphEvent
    */
    func addItem(item: CALayer) -> GraphEvent {
        items.append(item)
        return self
    }
    
    func addArticulation(articulation: Articulation) -> GraphEvent {
        articulations.append(articulation)
        return self
    }
    
    func startSlur() {
        startsSlur = true
        var y: CGFloat = getMaxInfoY() + 10
        let slur: Slur = Slur().setStartPoint(CGPointMake(x, y))
    }
    
    func endSlur() {
        endsSlur = true
        // something else
        //slur.setEndPoint(CGPointMake(x, getMaxInfoY()))
    }
    
    // MARK: Analysis
    
    /**
    Get if GraphEvent is a rest
    
    :returns: Bool
    */
    func getIsRest() -> Bool {
        return items.count == 0 ? true : false
    }
    
    /**
    Get y-value of endpoint of Stem
    
    :returns: CGFloat: y-value of endpoint of Stem
    */
    func getStemInfoEndY() -> CGFloat {
        let beamGroup = bgLeaf!.bgContainer!.beamGroup!
        if beamGroup.o == 1 {
            let beamGroupHeight = beamGroup.frame.height + beamGroup.externalPads.getBottom()
            let stratumDisplace = graph!.frame.minY - beamGroup.frame.maxY
            return beamGroupHeight + stratumDisplace + maxInfoY
        }
        else {
            let stratumDisplace = beamGroup.frame.minY - graph!.frame.minY
            return -(stratumDisplace + minInfoY)
        }
    }
    
    /**
    Get maximum y-value of events in GraphEvent within Graph layer
    
    :returns: CGFloat: maximum y-value of events in GraphEvent within Graph layer
    */
    func getMaxInfoY() -> CGFloat {
        /* override in subclasses if necessary */
        var maxInfoY: CGFloat?
        if items.count == 0 { return graph!.frame.maxY }
        for item in items {
            if maxInfoY == nil { maxInfoY = item.frame.maxY }
            else if item.frame.maxY > maxInfoY { maxInfoY = item.frame.maxY }
        }
        return maxInfoY!
    }
    
    /**
    Get minimum y-value of events in GraphEvent within Graph layer
    
    :returns: CGFloat: minimum of y-value of events in GraphEvent within Graph layer
    */
    func getMinInfoY() -> CGFloat {
        /* override in subclasses if necessary */
        var minInfoY: CGFloat?
        if items.count == 0 { return 0 }
        for item in items {
            if minInfoY == nil { minInfoY = item.frame.minY }
            else if item.frame.minY > maxInfoY { minInfoY = item.frame.minY }
        }
        return minInfoY!
    }
}