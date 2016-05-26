/**
Syncopation of sequence of SpanNodes to an metronome prototype (collection of 2s and 3s)
*/
class Syncopation {
    
    // MARK: Components
    
    /// Array of SpanNodes
    var sequence: [SpanNode]
    
    /// Collection of 2s and 3s
    var prototype: [Int]
    
    /// Array of tuples: (SpanNode, accumBeats)
    var sequenceWithAccumBeats: [(SpanNode, Int)] = []
    
    /// Array of tuples: (SpanNode, accumBeats)
    var prototypeWithAccumBeats: [(SpanNode, Int)] = []
    
    /// Sum of beats in sequence / prototype
    var sum: Int = 0
    
    /// Value of syncopation between sequence and prototype
    var value: Float = 0
    
    // MARK: Create a Syncoptaiton
    
    /**
    Create a Syncopation with sequence of SpanNodes and metronome prototype (collection of 2s and 3s)
    
    :param: sequence  Array of SpanNodes
    :param: prototype Collection of 2s and 3s
    
    :returns: Self: Syncopation
    */
    init(sequence: [SpanNode], prototype: [Int]) {
        self.sequence = sequence
        self.prototype = prototype
        createSequenceAndPrototypeWithAccumBeats()
        getSyncopation()
    }
    
    /**
    Get value of Syncopation: consider reorganizing
    */
    func getSyncopation() {
        var sync: Float = 0.0
        var seq = sequenceWithAccumBeats
        var proto = prototypeWithAccumBeats
        traverseToGetSyncopation(prototype: &proto, sequence: &seq, syncopation: &sync)
        value = sync
    }
    
    private func traverseToGetSyncopation(
        inout #prototype: [(SpanNode, Int)],
        inout sequence: [(SpanNode, Int)],
        inout syncopation: Float
    ) {
        let (firstSeqNode, firstSeqAccumBeats) = sequence[0]
        let (firstProtoNode, firstProtoAccumBeats) = prototype[0]
        
        // ON BEAT
        if firstSeqAccumBeats == firstProtoAccumBeats {
            //println("ON BEAT: chop off first of both")
            // chop off first event of both
            prototype.removeAtIndex(0)
            sequence.removeAtIndex(0)
            if sequence.count > 1 {
                traverseToGetSyncopation(
                    prototype: &prototype,
                    sequence: &sequence,
                    syncopation: &syncopation
                )
            }
        }
        // BEFORE BEAT
        else if firstSeqAccumBeats < firstProtoAccumBeats {
            // println("BEFORE BEAT: search for delayedMatch")
            
            // consider the delayedMatch(Index) situation; how can this be reused?
            
            // check for delayed match
            var delayedMatch: Bool = false
            var delayedMatchIndex: Int?
            // if less than 2 events left to test: set delayedMatch to true; index to 1
            
            // perhaps this is unecessary?!
            if sequence.count < 2 {
                delayedMatch = true
                delayedMatchIndex = 1
            }
            else {
                // search for delayed match: encapsulate
                
                // SEARCH IN SEQUENCE
                for i in 1..<sequence.count - 1 {
                    let (seqNode, seqAccumBeats) = sequence[i]
                    
                    // CHECK <=
                    if seqAccumBeats <= firstProtoAccumBeats {
                        delayedMatch = true
                        delayedMatchIndex = i
                        break
                    }
                }
                // if delayed match: figure out way of encapsulating this for all sim cases
                if delayedMatch {
                    // println("BEFORE BEAT: delayedMatch")
                    for c in 0..<delayedMatchIndex! { sequence.removeAtIndex(0) }
                    
                    // particularly find a way to encapsulate this guy!
                    if sequence.count > 1 {
                        traverseToGetSyncopation(
                            prototype: &prototype,
                            sequence: &sequence,
                            syncopation: &syncopation
                        )
                    }
                }
                else {
                    // println("BEFORE BEAT: no delayedMatch")
                    
                    // add syncopation: later: 
                    // ADD WEIGHT for compound-beats (prototype); .isContainer (sequence)
                    
                    if prototype.count > 1 { syncopation += 1.0 }
                    
                    //chop off first event of sequence
                    sequence.removeAtIndex(0)
                    
                    // should be encapsulated
                    if sequence.count > 1 {
                        traverseToGetSyncopation(
                            prototype: &prototype,
                            sequence: &sequence,
                            syncopation: &syncopation
                        )
                    }
                }
            }
        }
        // AFTER BEAT
        else if firstSeqAccumBeats > firstProtoAccumBeats {
            // println("ATER BEAT")
            var delayedMatch: Bool = false
            var delayedMatchIndex: Int?
            
            // perhaps this is unecessary?!
            if sequence.count < 2 {
                delayedMatch = true
                delayedMatchIndex = 1
            }
            else {
                
                // SEARCH IN PROTOTYPE
                for i in 1..<prototype.count {
                    let (prototypeNode, prototypeAccumBeats) = prototype[i]
                    let (secondSeqNode, secondSeqAccumBeats) = sequence[1]
                    
                    
                    // CHECK: <=, and that secondSeq... is the right thing to check against
                    if prototypeAccumBeats <= secondSeqAccumBeats {
                        delayedMatch = true
                        delayedMatchIndex = i
                        break
                    }
                }
            }
            if delayedMatch {
                // println("AFTER BEAT: delayedMatch")
                if sequence.count > 1 {
                    for c in 0..<delayedMatchIndex! { prototype.removeAtIndex(0) }
                    traverseToGetSyncopation(
                        prototype: &prototype,
                        sequence: &sequence,
                        syncopation: &syncopation
                    )
                }
            }
            else {
                // println("AFTER BEAT: no delayedMatch")
                
                // add syncopation: later:
                // ADD WEIGHT for compound-beats (prototype); .isContainer (sequence)
                syncopation += 1.0
                
                // chop off first event of both
                prototype.removeAtIndex(0)
                sequence.removeAtIndex(0)
                
                if sequence.count > 1 {
                    traverseToGetSyncopation(
                        prototype: &prototype,
                        sequence: &sequence,
                        syncopation: &syncopation
                    )
                }
            }
        }
    }
    
    private func createSequenceAndPrototypeWithAccumBeats() {
        createSequenceWithAccumBeats()
        createPrototypeWithAccumBeats()
    }
    
    private func createSequenceWithAccumBeats() {
        var accumBeats: Int = 0
        for node in sequence {
            accumBeats += node.duration.beats.amount
            let pair: (SpanNode, Int) = (node, accumBeats)
            sequenceWithAccumBeats.append(pair)
        }
    }
    
    private func createPrototypeWithAccumBeats() {
        var accumBeats: Int = 0
        for beats in prototype {
            let node: SpanNode = SpanNode(beats: beats)
            accumBeats += beats
            let pair: (SpanNode, Int) = (node, accumBeats)
            prototypeWithAccumBeats.append(pair)
        }
    }
}