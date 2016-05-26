import QuartzCore

/**
SpanTree: More discussion needed
*/
class SpanTree: Printable {
    
    var description: String { get { return getDescription() } }
    
    // offsetDuration
    var offsetDuration: Duration = Duration()
    
    // MARK: Hierarchical Context
    
    /// SpanNode root of SpanTree
    var root: SpanNode
    
    /// All leaves (SpanNodes with no children: musical events)
    var leaves = [SpanNode]()
    
    // MARK: Create a SpanTree
    
    /**
    Create a SpanTree with a SpanNode as root
    
    :param: root SpanNode
    
    :returns: Self: SpanTree
    */
    init(root: SpanNode) {
        self.root = root
    }
    
    /**
    Create a SpanTree with amount of beats, value of subdivision, and sequence of beats of children
    
    :param: beats       Amount of Beats
    :param: subdivision Value of Subdivision
    :param: sequence    Array of arbitrarily deep array of durational amounts
    
    :returns: Self: SpanTree
    */
    init(beats: Int, subdivision: Int, sequence: NSArray) {
        self.root = SpanNode(beats: beats, subdivision: subdivision).addSequence(sequence)
    }
    
    func setOffsetDuration(offsetDuration: Duration) -> SpanTree {
        self.offsetDuration = offsetDuration
        return self
    }
    
    /**
    For testing purposes only: Adds random pitches and dynamics to all leaves of SpanTree
    
    :returns: Self: SpanTree
    */
    
    // FOR TESTING ONLY: KILL
    func addRandomPitchAndDynamicInfoToLeaves() -> SpanTree {
        for leaf in getLeaves() {
            let pitchComponent = SpanComponent.Pitch(
                pID: "FL",
                iID: "FL",
                pitches: [randomMidi()]
            )
            leaf.addComponent(pitchComponent)
        }
        return self
    }
    
    // FOR TESTING ONLY: KILL 
    func addRandomPitchInfoToLeavesWithPerformerID(performerID: String) -> SpanTree {
        for leaf in getLeaves() {
            let pitch = SpanComponent.Pitch(
                pID: performerID,
                iID: performerID,
                pitches: [68.5, 75.25, 80]
            )
            leaf.addComponent(pitch)
        }
        return self
    }

    // MARK: Adjust a SpanTree
    
    /**
    Creates array of leaves
    
    :returns: Self: SpanTree
    */
    func flatten() -> SpanTree {
        traverseFlatten(root)
        return self
    }
    
    /**
    Adjusts durations of all children of SpanContainers
    
    :returns: Self: SpanTree
    */
    func clean() -> SpanTree {
        traverseClean(root)
        return self
    }
    
    // MARK: Analysis
    
    /**
    Get array of leaves
    
    :returns: Array of SpanNodes with no children (musical event)
    */
    func getLeaves() -> [SpanNode] {
        clean()
        leaves = []
        flatten()
        return leaves
    }
    
    /**
    Get depth of tree
    
    :returns: Int: depth of tree
    */
    func getDepth() -> Int {
        var maxDepth = 0
        for leaf in getLeaves() {
            var curDepth = leaf.getDepth()
            maxDepth = curDepth > maxDepth ? curDepth : maxDepth
        }
        return maxDepth
    }
    
    // ABSTRACT / ENCAPSULATE THESE THINGS!
    func matchParentToChildren(node: SpanNode) {
        node.cleanChildren()
        var beats: Int = node.duration.beats.amount
        var sum: Int = getSum(node.getBeatsList())
        var potential = [Float]()
        for exponent in -4..<4 {
            potential.append(Float(beats) * pow(2.0, Float(exponent)))
        }
        var closest: Float = getClosest(potential, Float(sum))
        var newSum = sum
        while !(closest % 1.0 == 0) { closest *= 2.0; newSum *= 2 }
        var parentScale = closest / Float(beats)
        var childScale = Float(newSum) / Float(sum)
        
        node.duration.scaleToBeats(Int(closest))
        for child in node.children! {
            child.duration.setSubdivision(node.duration.subdivision.value)
        }
    }
    
    private func traverseFlatten(node: SpanNode) {
        if node.isContainer { for child in node.children! { traverseFlatten(child) }
        } else { leaves.append(node) }
    }
    
    private func traverseClean(node: SpanNode) {
        if node.isContainer {
            matchParentToChildren(node)
            for child in node.children! { traverseClean(child) }
        }
    }
    
    private func getDescription() -> String {
        return "SpanTree: OffsetDuration: \(offsetDuration); Duration: \(root.duration)"
    }
}