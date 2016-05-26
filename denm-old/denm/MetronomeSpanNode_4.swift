import QuartzCore

/**
MetronomeSpanNode with 4 beats
*/
class MetronomeSpanNode_4: MetronomeSpanNode {
    
    /**
    Create a MetronomeSpanNode with 4 beats
    
    :returns: Self: MetronomeSpanNode_4
    */
    init() {
        super.init(beats: 4)
    }
    
    override internal func makeOrderedPrototypes() -> [[Int]] {
        let orderedPrototypes: [[Int]] = [[2,2]]
        return orderedPrototypes
    }
}