import QuartzCore

/**
MetronomeSpanNode
*/
class MetronomeSpanNode: SpanNode {

    // MARK: Components
    
    /// Array of SpanNodes
    var sequence: [SpanNode] = []

    // MARK: Create a MetronomeSpanNode
    
    // Create a MetronomeSpanNode with amount of beats
    override init(beats: Int) {
        super.init(beats: beats)
     }
    
    // MARK: Incrementally build a MetonomeSpanNode
    
    /**
    Set array of SpanNodes
    
    :param: sequence Array of SpanNodes
    
    :returns: Self: MetronomeSpanNode
    */
    func setSequence(sequence: [SpanNode]) -> MetronomeSpanNode {
        self.sequence = sequence
        
        // search for repeated durations, and clump if possible
        // this is done if there are multiple leastSyncopated
        
        // perhaps more elegant way than this?
        duration.setSubdivision(sequence[0].duration.subdivision.value)
        addChildrenWithSequence()
        return self
    }
    
    /**
    Add child
    
    :param: node SpanNode with amount of beats being 2 or 3
    
    :returns: Self: SpanNode
    */
    override func addChild(node: SpanNode) -> SpanNode {
        var children = self.children != nil ? self.children! : [SpanNode]()
        node.parent = self
        node.duration.setSubdivision(duration.subdivision.value)
        children.append(node)
        self.children = children
        return self
    }

    
    internal func getBeats() -> Int {
        
        return 0
    }
    
    internal func addChildren() -> MetronomeSpanNode {

        return self
    }
    
    /**
    Add SpanNode children with beats of sequence
    
    :returns: Self: MetronomSpanNode
    */
    func addChildrenWithSequence() -> MetronomeSpanNode {
        let metronomePrototypes = makeMetronomePrototypes(sequence: sequence)
        let metronomePrototype = getBestFittingPrototype(metronomePrototypes)
        for beats in metronomePrototype { addChild(MetronomeSpanNode(beats: beats)) }
        return self
    }

    /**
    Get best fitting prototype (from arrays of 2s, 3s, with priority, syncoption)
    
    :param: prototypes Array of MetronomePrototypes
    
    :returns: Array of 2s and 3s
    */
    func getBestFittingPrototype(prototypes: [MetronomePrototype]) -> [Int] {
        var metronomePrototypes = prototypes
        if metronomePrototypes.count == 1 { return metronomePrototypes[0].prototype }
        else {
            metronomePrototypes.sort { $0.syncopation! < $1.syncopation! }
            ensureOnlyLeastSyncopatedRemain(&metronomePrototypes)
            metronomePrototypes.sort { $0.priority < $1.priority }
        }
        return metronomePrototypes[0].prototype
    }
    
    internal func makeMetronomePrototypes(#sequence: [SpanNode]) -> [MetronomePrototype] {
        var metronomePrototypes: [MetronomePrototype] = []
        let orderedPrototypes: [[Int]] = makeOrderedPrototypes()
        for (priority, prototype) in enumerate(orderedPrototypes) {
            let syncopation: Float = getSyncopation(sequence: sequence, prototype: prototype)
            let metronomePrototype = MetronomePrototype(prototype: prototype)
                .setPriority(priority)
                .setSyncopation(syncopation)
            metronomePrototypes.append(metronomePrototype)
        }
        return metronomePrototypes
    }
    
    internal func ensureOnlyLeastSyncopatedRemain(inout metronomePrototypes: [MetronomePrototype]) {
        var thisPoint: Int?
        for m in 0..<metronomePrototypes.count {
            if metronomePrototypes[m].syncopation! > metronomePrototypes[0].syncopation! {
                thisPoint = m
                break
            }
        }
        if thisPoint != nil { trimOffEnd(at: thisPoint!, seq: &metronomePrototypes) }
    }
    
    internal func trimOffEnd(#at: Int, inout seq: [MetronomePrototype]) {
        while seq.count > at { seq.removeAtIndex(at) }
    }
    
    internal func makeOrderedPrototypes() -> [[Int]] {

        return []
    }
    
    internal func getSyncopation(#sequence: [SpanNode], prototype: [Int]) -> Float {
        let syncopation: Float = Syncopation(sequence: sequence, prototype: prototype).value
        return syncopation
    }
}