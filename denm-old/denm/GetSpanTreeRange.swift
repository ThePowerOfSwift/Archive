import UIKit

class GetSpanTreeRange {
    
    /// Resource
    var selectedSpanTrees: [SpanTree] = []
    var offsetDuration: Duration = Duration()
    
    /// Constraint
    var maximumDuration: Duration = Duration()
    
    func setOffsetDuration(duration: Duration) -> GetSpanTreeRange {
        self.offsetDuration = duration
        return self
    }
    
    func setMaximumDuration(duration: Duration) -> GetSpanTreeRange {
        self.maximumDuration = duration
        return self
    }
    
    func getRangeFromSpanTrees(spanTrees: [SpanTree]) -> [SpanTree] {
        for spanTree in spanTrees {
            if spanTreeIsInDurationRange(spanTree: spanTree) { addSpanTree(spanTree) }
        }
        return selectedSpanTrees
    }
    
    func addSpanTree(spanTree: SpanTree) {
        selectedSpanTrees.append(spanTree)
    }
    
    func spanTreeIsInDurationRange(#spanTree: SpanTree) -> Bool {
        let systemBegin: Duration = offsetDuration
        let systemEnd: Duration = offsetDuration + maximumDuration
        let spanTreeBegin: Duration = spanTree.offsetDuration
        let spanTreeEnd: Duration = spanTree.offsetDuration + spanTree.root.duration
        return spanTreeBegin >= systemBegin && spanTreeEnd <= systemEnd
    }
}