import Darwin

/**
Hierarchical representation of metronome (temporal scaffolding) attached to SpanNode
*/
class MetronomeSpanTree: SpanTree {
    
    // MARK: SpanNode
    
    /// MetronomeSpanTree is created for reference SpanNode
    var refNode: SpanNode
    
    /// Graphical and Temporal scale, inherited through arbitrarily deep embeddings in Tree
    var inheritedScale: Float = 0
    
    // MARK: Create a MetronomeSpanTree
    
    /**
    Create a MetronomeSpanTree with a reference SpanNode
    
    :param: refNode Reference SpanNode
    
    :returns: Self: MetronomeSpanTree
    */
    init(refNode: SpanNode) {
        self.refNode = refNode
        let (_,b,l) = refNode.getTupletDisplayInfo()
        let duration = Duration(beats: Beats(b), subdivision: Subdivision(level: l))
        let rootNode: SpanNode = SpanNode(duration: duration)
        super.init(root: rootNode)
        setInheritedScale()
        addChildrenBasedOnSum()
    }
    
    func getTemporalScale() {
        
    }
    
    /**
    Get syncopation of metronome prototype and sequence of amount of Beats
    
    :param: prototype Collection of 2s and 3s
    :param: sequence  Sequence of amount of Beats
    */
    func getSyncopation(#prototype: [Int], sequence: [Int]) {
        var prototype: [Int] = getCumulative(prototype)
        var sequence: [Int] = getCumulative(sequence)
        var syncopation: Float = 0.0
        traverseToGetSyncopation(
            prototype: &prototype, sequence: &sequence, syncopation: &syncopation
        )
    }
    
    private func traverseToGetSyncopation(
        inout #prototype: [Int], inout sequence: [Int], inout syncopation: Float
    ) {
        // check if event is on-beat
        if sequence[0] == prototype[0] {
            
            //println("ON BEAT")
            
            // no syncopation added
            
            // chop off first event of both arrays
            prototype.removeAtIndex(0)
            sequence.removeAtIndex(0)
            traverseToGetSyncopation(
                prototype: &prototype, sequence: &sequence, syncopation: &syncopation
            )
        }
        // check if event is before-beat
        else if sequence[0] < prototype[0] {
            
            //println("BEFORE BEAT")
            
            // delayed match isnt really the right word...before
            var delayedMatch: Bool = false
            var delayedMatchIndex: Int?
            for i in 1..<sequence.count {
                if sequence[i] <= prototype[0] {
                    delayedMatch = true
                    delayedMatchIndex = i
                    break
                }
            }
            if delayedMatch {
                // no syncopation added
                
                // chop off first event
                prototype.removeAtIndex(0)
                
                // chop off events through delayedMatchIndex (to start next from dMI + 1)
                for c in 0...delayedMatchIndex! { sequence.removeAtIndex(0) }
            }
            else {
                // add syncopation
                syncopation += 1.0
                prototype.removeAtIndex(0)
                sequence.removeAtIndex(0)
                if prototype.count > 1 {
                    
                    // continue
                    traverseToGetSyncopation(
                        prototype: &prototype, sequence: &sequence, syncopation: &syncopation
                    )
                }
            }
        }
        // check if event is after-beat
        else if sequence[0] > prototype[0] {
            
            //println("AFTER BEAT")
            
            var delayedMatch: Bool = false
            var delayedMatchIndex: Int?
            for i in 1..<prototype.count {
                if sequence[0] >= prototype[i] {
                    delayedMatch = true
                    delayedMatchIndex = i
                    break
                }
            }
            if delayedMatch {
                if sequence.count > 1 {
                    
                    // chop off elements 0-delayedMatchIndex - 1 of prototype
                    for c in 0..<delayedMatchIndex! { prototype.removeAtIndex(0) }
                    
                    // continue
                    traverseToGetSyncopation(
                        prototype: &prototype, sequence: &sequence, syncopation: &syncopation
                    )
                }
            }
            else {
                // add syncopation
                syncopation += 1.0
                
                // chop off first event of both
                prototype.removeAtIndex(0)
                sequence.removeAtIndex(0)
                
                if sequence.count > 1 {
                    traverseToGetSyncopation(
                        prototype: &prototype, sequence: &sequence, syncopation: &syncopation
                    )
                }
            }
        }
    }
    
    
    func addChildrenBasedOnSum() {
        
        // DEPRECATED!
        
        // for now: split up: < 9, > 9; < 17 ([b,s] both under 9)
        let sum: Int = getSum(refNode.getBeatsList())
        let metronomeSpanNode = CreateMetronomeSpanNode().withSequence(refNode.children!)!
        root.children = metronomeSpanNode.children!
    }
    
    func setInheritedScale() -> MetronomeSpanTree {
        inheritedScale = refNode.getInheritedScale()
        return self
    }
}