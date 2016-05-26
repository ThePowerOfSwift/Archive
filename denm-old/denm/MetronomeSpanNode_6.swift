import QuartzCore

/**
MetronomeSpanNode with 6 beats
*/
class MetronomeSpanNode_6: MetronomeSpanNode {
    
    /**
    Create a MetronomeSpanNode with 6 beats
    
    :returns: Self: MetronomeSpanNode_6
    */
    init() {
        super.init(beats: 6)
    }
    
    override internal func makeOrderedPrototypes() -> [[Int]] {
        let orderedPrototypes: [[Int]] = [[2,2,2],[3,3]]
        return orderedPrototypes
    }
}