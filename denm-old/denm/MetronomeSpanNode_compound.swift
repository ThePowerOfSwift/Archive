import QuartzCore

/**
This is a Metoome Span Node Compound
*/
class MetronomeSpanNode_compound: MetronomeSpanNode {
    
    // MARK: Create a MetronomeSpanNode_compound
    
    /**
    Create a MetronomeSpanNode_compound
    
    :returns: Self: MetronomeSpanNode
    */
    init() {
        super.init(beats: 1)
    }
    
    /**
    Overrides MetronomeSpanNode.setSequence()
    i
    :param: sequence Set sequence of SpanNodes
    
    :returns: Self: MetronomeSpanNode
    */
    override func setSequence(sequence: [SpanNode]) -> MetronomeSpanNode {
        self.sequence = sequence
        setDurationWithSequence()
        addChildrenWithSequence()
        return self
    }
    
    /**
    Add children with seq
    
    :returns: Self: MetronomeSpanNode
    */
    override func addChildrenWithSequence() -> MetronomeSpanNode {
        let metronomePrototypes = makeMetronomePrototypes(sequence: sequence)
        let metronomePrototype = getBestFittingPrototype(metronomePrototypes)
        let sequences = clipSequence(sequence, prototype: metronomePrototype)
        for sequence in sequences {
            println("sequence:")
            for node in sequence {
                println("node: \(node.duration.beats.amount)")
            }
        }
        for sequence in sequences {
            let metronomeSpanNode = CreateMetronomeSpanNode().withSequence(sequence)!
            addChild(metronomeSpanNode)
        }
        return self
    }
    
    /**
    Clip seq
    
    :param: sequence  seq
    :param: prototype prototype
    
    :returns: Array of Arrays of SpanNodes
    */
    func clipSequence(sequence: [SpanNode], prototype: [Int]) -> [[SpanNode]] {
        var prototype = getCumulative(prototype)
        prototype.removeAtIndex(0)
        var sequences: [[SpanNode]] = []
        var accumBeats: Int = 0
        
        for node in sequence {
            
            // add to accumBeats
            accumBeats += node.duration.beats.amount
            println("accumBeats: \(accumBeats)")
            println("prototype[0]: \(prototype[0])")
            
            if accumBeats < prototype[0] {
                // add new [] if necessary
                if sequences.count == 0 { sequences.append([node]) }
                else { sequences[sequences.count-1].append(node) }
            }
            else if accumBeats == prototype[0] {
                // add node to []
                if sequences.count == 0 { sequences.append([node]) }
                else { sequences[sequences.count-1].append(node) }
                
                // add new node:
                if node !== sequence.last! { sequences.append([]) }
                
                // remove first prototype sum
                prototype.removeAtIndex(0)
            }
            else if accumBeats > prototype[0] {
                let newBeats: Int = accumBeats - prototype[0] // ex: 7:5 -> 2
                let oldBeats: Int = node.duration.beats.amount - newBeats // more elegant way?
                
                // add node to last []
                let oldSpanNode: SpanNode = SpanNode(beats: oldBeats)
                if sequences.count == 0 { sequences.append([oldSpanNode]) }
                else { sequences[sequences.count-1].append(oldSpanNode) }
                
                // add node to new []
                let newSpanNode: SpanNode = SpanNode(beats: newBeats)
                sequences.append([newSpanNode])
                
                prototype.removeAtIndex(0)
            }
        }
        return sequences
    }
    
    /**
    Make metronome proto
    
    :param: sequence seq
    
    :returns: Array of metronome proto
    */
    override func makeMetronomePrototypes(#sequence: [SpanNode]) -> [MetronomePrototype] {
        var metronomePrototypes: [MetronomePrototype] = []
        let orderedPrototypes = makeOrderedPrototypes()
        for (priority, prototype) in enumerate(orderedPrototypes) {
            let syncopation = getSyncopation(sequence: sequence, prototype: prototype)
            let metronomePrototype = MetronomePrototype(prototype: prototype)
                .setPriority(priority)
                .setSyncopation(syncopation)
            metronomePrototypes.append(metronomePrototype)
        }
        return metronomePrototypes
    }
    
    /**
    make ordered proto
    
    :returns: array of array of int
    */
    override func makeOrderedPrototypes() -> [[Int]] {
        var prototypes: [[Int]] = []
        let beats: Int = getSumOfSequence(sequence)
        var smaller: Int = Int(floor(Double(beats)/2.0))
        var bigger: Int = beats - smaller
        while smaller > 2 {
            let prototype1 = [bigger, smaller]
            let prototype2 = [smaller, bigger]
            prototypes.append(prototype1)
            prototypes.append(prototype2)
            smaller--
            bigger++
        }
        return prototypes
    }
    
    /**
    set dur with seq
    
    :returns: Self: MetronomeSpanNode
    */
    internal func setDurationWithSequence() -> MetronomeSpanNode {
        duration = Duration(
            beats: Beats(getSumOfSequence(sequence)),
            subdivision: Subdivision(sequence[0].duration.subdivision.value)
        )
        return self
    }
    
    /**
    Set sum of seq
    
    :param: sequence seq
    
    :returns: sum of seq
    */
    internal func getSumOfSequence(sequence: [SpanNode]) -> Int {
        var sum: Int = 0
        for node in sequence { sum += node.duration.beats.amount }
        return sum
    }
}