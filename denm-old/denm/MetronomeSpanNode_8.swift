import QuartzCore

/**
MetronomeSpanNode with 8 beats
*/
class MetronomeSpanNode_8: MetronomeSpanNode {
 
    /**
    Create a MetronomeSpanNode with 8 beats
    
    :returns: Self: MetronomeSpanNode_8
    */
    init() {
        super.init(beats: 8)
    }
    
    override internal func makeOrderedPrototypes() -> [[Int]] {
        let orderedPrototypes: [[Int]] = [[2,2,2,2],[3,3,2],[2,3,3],[3,2,3]]
        return orderedPrototypes
    }
}