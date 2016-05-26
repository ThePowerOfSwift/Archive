import QuartzCore

/**
MetronomeSpanNode with 5 beats
*/
class MetronomeSpanNode_5: MetronomeSpanNode {
    
    /**
    Create a MetronomeSpanNode with 5 beats
    
    :returns: Self: MetronomeSpanNode_5
    */
    init() {
        super.init(beats: 5)
    }
    
    override internal func makeOrderedPrototypes() -> [[Int]] {
        let orderedPrototypes: [[Int]] = [[3,2],[2,3]]
        return orderedPrototypes
    }
}