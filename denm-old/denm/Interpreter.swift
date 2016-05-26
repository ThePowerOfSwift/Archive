class Interpreter {
 
    /// All actions to be made in denm: input
    var actions: [Action] = []
    
    // output
    var measures: [Measure] = []
    var spanTrees: [SpanTree] = []
    
    // these are continuously being modified
    var spanContainerStack: [SpanNode] = []
    var curSpanLeaf: SpanNode?
    
    // continuously modified params
    var accumMeasureDur: Duration = Duration(0,16)
    var accumDur: Duration = Duration(0,16)
    var curDepth: Int = 0
    
    init(actions: [Action]) {
        self.actions = actions
    }
    
    func generate() -> ([SpanTree],[Measure]) {

        // for testing only
        let pID: String = "FL"
        let iID: String = "FL"
        
        for action in actions {
            var component: SpanComponent?
            switch action {
            case .Measure: createMeasure()
            case .SpanTree(let duration): createSpanTreeWithDuration(duration)
            case .SpanContainer(let amountBeats, let depth):
                createSpanContainerWithAmountBeats(amountBeats, depth: depth)
            case .SpanLeaf(let amountBeats, let depth):
                createSpanLeafWithAmountBeats(amountBeats, depth: depth)
            case .Pitch(let pitches):
                component = SpanComponent.Pitch(pID: pID, iID: iID, pitches: pitches)
            case .Dynamic(let marking):
                component = SpanComponent.Dynamic(pID: pID, iID: iID, marking: marking)
            case .Articulation(let marking):
                component = SpanComponent.Articulation(pID: pID, iID: iID, marking: marking)
            case .SlurStart:
                component = SpanComponent.SlurStart(pID: pID, iID: iID)
            case .SlurEnd:
                component = SpanComponent.SlurEnd(pID: pID, iID: iID)
            case .Rest:
                println("Interpreter: Rest")
                component = SpanComponent.Rest(pID: pID, iID: iID)
            default:
                break
            }
            addSpanComponentToCurSpanLeaf(spanComponent: component)
        }
        setDurationOfLastMeasure(duration: accumMeasureDur)
        return (spanTrees, measures)
    }
    
    func addSpanComponentToCurSpanLeaf(#spanComponent: SpanComponent?) {
        if spanComponent != nil { curSpanLeaf!.addComponent(spanComponent!) }
    }

    func createMeasure() {
        setDurationOfLastMeasure(duration: accumMeasureDur)
        addMeasure(Measure(offsetDuration: accumDur))
        resetAccumMeasureDurToZero()
    }
    
    func addMeasure(measure: Measure) {
        measures.append(measure)
    }
    
    func createSpanContainerWithAmountBeats(amountBeats: Int, depth: Int) {
        let spanContainer: SpanNode = SpanNode(beats: amountBeats)
        popAmountFromSpanContainerStackWithDepthIfNecessary(depth: depth)
        addSpanNodeToLastSpanContainer(spanContainer)
        pushSpanContainerToStack(spanContainer: spanContainer)
        setCurDepth(depth)
    }
    
    func createSpanLeafWithAmountBeats(amountBeats: Int, depth: Int) {
        let spanLeaf: SpanNode = SpanNode(beats: amountBeats)
        popAmountFromSpanContainerStackWithDepthIfNecessary(depth: depth)
        addSpanNodeToLastSpanContainer(spanLeaf)
        setCurSpanLeaf(spanLeaf)
        setCurDepth(depth)
    }
    
    func popAmountFromSpanContainerStackWithDepthIfNecessary(#depth: Int) {
        if depth < curDepth {
            var amount: Int = curDepth - depth
            popAmountFromSpanContainerStack(amount: amount)
        }
    }
    
    func pushSpanContainerToStack(#spanContainer: SpanNode) {
        spanContainerStack.append(spanContainer)
    }
    
    func addSpanNodeToLastSpanContainer(spanNode: SpanNode) {
        spanContainerStack.last!.addChild(spanNode)
    }
    
    func setCurSpanLeaf(spanLeaf: SpanNode) {
        curSpanLeaf = spanLeaf
    }
    
    func setCurDepth(depth: Int) {
        curDepth = depth
    }
    
    func createSpanTreeWithDuration(duration: (Int, Int)) {
        // empty spanContainerStack and spanLeafStack
        let (beats, subdivision) = duration
        let root: SpanNode = SpanNode(beats: beats, subdivision: subdivision)
        let spanTree: SpanTree = SpanTree(root: root).setOffsetDuration(accumDur)
        addSpanTree(spanTree)
        spanContainerStack = [root]
        setCurDepth(0)
        accumMeasureDur += root.duration
        accumDur += root.duration
    }
    
    func addSpanTree(spanTree: SpanTree) {
        spanTrees.append(spanTree)
    }
    
    func setDurationOfLastMeasure(#duration: Duration) {
        if measures.count > 0 { measures.last!.setDuration(duration) }
    }
    
    func resetAccumMeasureDurToZero() {
        accumMeasureDur = Duration(0,16)
    }
    
    func popAmountFromSpanContainerStack(#amount: Int) {
        for _ in 0..<amount { spanContainerStack.removeLast() }
    }
}