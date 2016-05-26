import QuartzCore

/**
MetronomeSpanNode with 7 beats
*/
class MetronomeSpanNode_7: MetronomeSpanNode {

    /**
    Create MetronomeSpanNode with 7 beats
    
    :returns: Self: MetronomeSpanNode
    */
    init() {
        super.init(beats: 7)
    }
    
    override internal func makeOrderedPrototypes() -> [[Int]] {
        let orderedPrototypes: [[Int]] = [[3,2,2],[2,2,3],[2,3,2]]
        return orderedPrototypes
    }
}