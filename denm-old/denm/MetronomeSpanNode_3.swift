import QuartzCore

/**
MetronomeSpanNode with 3 beats
*/
class MetronomeSpanNode_3: MetronomeSpanNode {
    
    /**
    Create a MetronomeSpanNode with 3 beats
    
    :returns: Self: MetronomeSpanNode_3
    */
    init() {
        super.init(beats: 3)
    }
    
    override internal func makeOrderedPrototypes() -> [[Int]] {
        let orderedPrototypes: [[Int]] = [[3]]
        return orderedPrototypes
    }
}