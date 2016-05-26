import QuartzCore

/**
SpanNode: More discussion needed
*/
class SpanNode: Printable {
    
    // MARK: Attributes
    
    /// Printable description of SpanNode
    var description: String { get { return getDescription() } }
    
    /// Duration of SpanNode
    var duration: Duration
    
    /// Hierarchical Context
    
    /// Parent SpanNode
    var parent: SpanNode?
    
    /// Children SpanNodes
    var children: [SpanNode]?
    
    /// Depth in embedded tuplet
    var depth: Int { get { return getDepth() } }
    
    // MARK: Metronome Span Tree
    
    var metronomeSpanTree: MetronomeSpanTree { get { return getMetronomeSpanTree() } }
    
    // MARK: Span Components
    
    /// Musical material occurring at this SpanNode
    var components: [SpanComponent] = []
    
    // MARK: Analysis
    
    /// If SpanNode is a container of SpanNodes
    var isContainer: Bool { get { return children == nil ? false : true } }
    
    /// If SpanNode is a rest
    var isRest: Bool { get { return getIsRest() } }
    
    // MARK: Create a SpanNode
    
    /**
    Create a SpanNode with Duration
    
    :param: duration Duration
    
    :returns: Self: SpanNode
    */
    init(duration: Duration) {
        self.duration = duration
    }
    
    /**
    Create a SpanNode with amount of Beats
    
    :param: beats amount of Beats
    
    :returns: Self: SpanNode
    */
    init(beats: Int) {
        self.duration = Duration(
            beats: Beats(beats),
            subdivision: Subdivision(1)
        )
    }

    /**
    Create a SpanNode with amount of beats and value of subdivision
    
    :param: beats       amount of Beats
    :param: subdivision value of Subdivision (8, 16, 32, 64, 128, etc.)
    
    :returns: Self: SpanNode
    */
    init(beats: Int, subdivision: Int) {
        self.duration = Duration(
            beats: Beats(beats),
            subdivision: Subdivision(subdivision)
        )
    }
    
    // MARK: Incrementally build a SpanNode
    
    /*
    /**
    Set if SpanNode is a rest
    
    :param: isRest Bool
    
    :returns: Self: SpanNode
    */
    func setIsRest(isRest: Bool) -> SpanNode {
        self.isRest = isRest
        return self
    }
    */
    
    /**
    Add child node
    
    :param: node SpanNode
    
    :returns: Self: SpanNode
    */
    func addChild(node: SpanNode) -> SpanNode {
        var children = self.children != nil ? self.children! : [SpanNode]()
        node.parent = self
        children.append(node)
        self.children = children
        return self
    }
    
    /**
    Add a sequence of Beats as children to SpanNode: this may come in a format of arbitrarily
    embedded NSArrays, in a way similar to OpenMusic RhythmTree notation
    
    :param: sequence Ordered collection of amount of Beats
    
    :returns: Self: SpanNode
    */
    func addSequence(sequence: NSArray) -> SpanNode {
        traverseToAddSequence(sequence, parent: self)
        return self
    }
    
    /**
    Add SpanComponent
    
    :param: spanComponent Musical information occurring at SpanNode
    
    :returns: Self: SpanNode
    */
    func addComponent(spanComponent: SpanComponent) -> SpanNode {
        components.append(spanComponent)
        return self
    }
    
    /**
    Create a MetronomeSpanTree for SpanNode (perhaps more discussion, images)
    */
    func getMetronomeSpanTree() -> MetronomeSpanTree {
        let metronomeSpanTree = MetronomeSpanTree(refNode: self)
        return metronomeSpanTree
    }
    
    // MARK: Analysis
    
    /**
    Get the cumulative scale, if embedded (for use graphically, and sonically)
    
    :returns: inherited scale
    */
    func getInheritedScale() -> Float {
        var scale: Float = 1.0
        climbScale(self, scale: &scale)
        return scale
    }
    
    /**
    Get level embedded in tuplet
    
    :returns: depth
    */
    func getDepth() -> Int {
        var depth: Int = 0
        climbDepth(self, depth: &depth)
        return depth - 1
    }
    
    /**
    Get graphical width of SpanNode
    
    :param: beatWidth Graphical width of a single 8th-note
    
    :returns: graphical width of SpanNode
    */
    func getWidth(beatWidth: CGFloat) -> CGFloat {
        return duration.getGraphicalWidth(beatWidth) * CGFloat(getInheritedScale())
    }
    
    /**
    Get temporal width of SpanNode
    
    :param: beatDuration Temporal length of a single 8th-note
    
    :returns: temporal length of SpanNode
    */
    func getLength(beatDuration: Double) -> Double {
        return duration.getTemporalLength(beatDuration) * Double(getInheritedScale())
    }
    
    /**
    Get beats list
    
    :returns: Array of amount of Beats in duration of all children
    */
    func getBeatsList() -> [Int] {
        var beatsList = [Int]()
        if children != nil {
            for child in children! { beatsList.append(child.duration.beats.amount) }
        }
        return beatsList
    }
    
    /**
    Get tuplet displace info
    
    :returns: Tuplet (Sum of children Beats, amoutn of Beats in Duration, Subdivision Level)
    */
    func getTupletDisplayInfo() -> (Int, Int, Int) {
        if children != nil {
            matchToChildren()
            var sum = getSum(getBeatsList())
            var beats = duration.beats.amount
            var level = duration.subdivision.level
            return (sum, beats, level)
        }
        else { return (0,0,0) }
    }
    
    func getIsRest() -> Bool {
        for component in components {
            switch component {
            case .Rest: return true
            default: break
            }
        }
        return false
    }
    
    // MARK: Adjust a SpanNode
    
    /**
    Clean children
    
    - level Durations of children to same subdivision value
    - reduce Durations of children to same subdivision value
    :returns: Self: SpanNode
    */
    func cleanChildren() -> SpanNode {
        levelChildren()
        reduceChildren()
        return self
    }
    
    /**
    Reduce children (reduce durations of children to same subdivision value)
    
    :returns: Float: Greatest Common Denominator (unneeded)
    */
    func reduceChildren() -> Float {
        if children != nil {
            var beatsList = getBeatsList()
            var gcd: Float = Float(reduce(&beatsList))
            for child in children! { child.duration.reduceBy(gcd) }
            return gcd
        }
        else { return 1 }
    }
    
    /**
    Level children (reduce durations of children to same subdivision value)
    
    :returns: Int: Maximum Subdivision Value
    */
    func levelChildren() -> Int {
        if children != nil {
            // get maxSubdVal
            var maxSubdVal: Int = 0
            for child in children! {
                var subdVal = child.duration.subdivision.value
                if subdVal > maxSubdVal { maxSubdVal = subdVal }
            }
            // adjust duration to match
            for child in children! {
                var subdVal = child.duration.subdivision.value
                if subdVal < maxSubdVal { child.duration.scaleToSubdivisionValue(maxSubdVal) }
            }
            return maxSubdVal
        }
        else { return 0 }
    }
    
    /**
    Adjust parent Duration such that amount of Beats is closest to sum of children beats
    */
    func matchToChildren() {
        cleanChildren()
        var beats: Int = duration.beats.amount
        var sum: Int = getSum(getBeatsList())
        var potential = [Float]()
        for exponent in -4..<4 { potential.append(Float(beats) * pow(2.0, Float(exponent))) }
        var closest: Float = getClosest(potential, Float(sum))
        var newSum = sum
        while !(closest % 1.0 == 0) { closest *= 2.0; newSum *= 2 }
        var childScale = Float(sum) / Float(newSum)
        duration.scaleToBeats(Int(closest))
        for child in children! { child.duration.reduceBy(childScale) }
    }
    
    private func traverseToAddSequence(sequence: NSArray, parent: SpanNode) {
        for el in sequence {
            if let leafBeats = el as? Int {
                let leafNode: SpanNode = SpanNode(beats: abs(leafBeats))
                // if leafBeats < 0 { leafNode.setIsRest(true) }
                parent.addChild(leafNode)
            }
            else if let container = el as? NSArray {
                var node: SpanNode?
                if let beats = container[0] as? Int {
                    node = SpanNode(beats: beats)
                    parent.addChild(node!)
                }
                if let seq = container[1] as? NSArray {
                    traverseToAddSequence(seq, parent: node!)
                }
            }
        }
    }
    
    private func climbScale(node: SpanNode, inout scale: Float) {
        if node.parent != nil {
            scale *= node.getLocalScale()
            climbScale(node.parent!, scale: &scale)
        }
    }
    
    private func climbDepth(node: SpanNode, inout depth: Int) {
        depth++
        if node.parent != nil { climbDepth(node.parent!, depth: &depth) }
    }
    
    func getLocalScale() -> Float {
        if parent == nil { return 1 } // root
            
        // ENCAPSULATE!
        else {
            var scale: Float = 1
            var beats: Int = parent!.duration.beats.amount
            var sum: Int = getSum(parent!.cleanChildren().getBeatsList())
            var potential = [Float]()
            for exponent in -4..<4 {
                potential.append(Float(beats) * pow(2.0, Float(exponent)))
            }
            var closest: Float = getClosest(potential, Float(sum))
            while !(closest % 1.0 == 0) { closest *= 2.0; sum *= 2 }
            scale = closest / Float(sum)
            if closest == Float(sum) { return 1 }
            else { return scale }
        }
    }
    
    private func getDescription() -> String {
        var description: String = "SpanNode: \(duration)"
        for component in components {
            switch component {
            case .Rest: description += "; Rest"
            case .Pitch(_, _, let pitches):
                description += "; Pitch: "
                for (p, pitch) in enumerate(pitches) {
                    if p > 0 { description += ", " }
                    description += "\(pitch)"
                }
            case .Dynamic(_, _, let marking): description += "; \(marking)"
            case .Articulation(_, _, let marking): description += "; Articulation: \(marking)"
            case .SlurStart: description += "; Start Slur"
            case .SlurEnd: description += "; End Slur"
            default: break
            }
        }
        return description
    }
}