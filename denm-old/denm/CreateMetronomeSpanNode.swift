/**
MetronomeSpanNode Factory
*/
class CreateMetronomeSpanNode {
    
    /**
    Create MetronomeSpanNode with Array of SpanNodes
    
    :param: sequence Array of SpanNodes
    
    :returns: MetronomeSpanNode?
    */
    func withSequence(sequence: [SpanNode]) -> MetronomeSpanNode? {
        let sum: Int = getSumOfSequence(sequence)
        var metronomeSpanNode: MetronomeSpanNode?
        if sum == 3 { metronomeSpanNode = MetronomeSpanNode_3() }
        if sum == 4 { metronomeSpanNode = MetronomeSpanNode_4() }
        if sum == 5 { metronomeSpanNode = MetronomeSpanNode_5() }
        if sum == 6 { metronomeSpanNode = MetronomeSpanNode_6() }
        if sum == 7 { metronomeSpanNode = MetronomeSpanNode_7() }
        if sum == 8 { metronomeSpanNode = MetronomeSpanNode_8() }
        if sum >  8 { metronomeSpanNode = MetronomeSpanNode_compound() }
        metronomeSpanNode!.setSequence(sequence)
        return metronomeSpanNode
    }
    
    private func getSumOfSequence(sequence: [SpanNode]) -> Int {
        var sum: Int = 0
        for node in sequence { sum += node.duration.beats.amount }
        return sum
    }
}