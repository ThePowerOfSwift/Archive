import QuartzCore

/**
BeamJunction Factory
*/
class CreateBeamJunction {
    
    /**
    Create a BeamJunction with context
    
    :param: i     Index of current event in array of BGLeaves
    :param: array Array of BGLeaves
    
    :returns: BeamJunction?
    */
    func withContext(#i: Int, array: [BGLeaf]) -> BeamJunction? {
        
        // Single Event
        if array.count == 1 {
            let cur = array[i]
            let levelCur = cur.spanLeaf!.duration.subdivisionLevel
            return BeamJunctionOrdSingle(cur: levelCur)
        }
        // First in BeamGroup
        else if i == 0 {
            let cur = array[i]
            let next = array[i + 1]
            let levelCur = cur.spanLeaf!.duration.subdivisionLevel
            if cur.spanLeaf!.parent! !== next.spanLeaf!.parent! {
                return BeamJunctionExtendedSingle(cur: levelCur)
            }
            else {
                let levelNext = next.spanLeaf!.duration.subdivisionLevel
                return BeamJunctionOrdFirst(cur: levelCur, next: levelNext)
            }
        }
        // Middle in multiple
        else if i > 0 && i < array.count - 1 {
            let prev = array[i - 1]
            let cur = array[i]
            let next = array[i + 1]
            let levelCur = cur.spanLeaf!.duration.subdivisionLevel
            
            if ( // Single in Container
                cur.spanLeaf!.parent! !== prev.spanLeaf!.parent! &&
                cur.spanLeaf!.parent! !== next.spanLeaf!.parent!
            ) {
                return BeamJunctionExtendedSingle(cur: levelCur)
            }
            
            if ( // First in Container
                cur.spanLeaf!.parent! !== prev.spanLeaf!.parent! &&
                cur.spanLeaf!.parent! === next.spanLeaf!.parent!
            ) {
                let levelNext = next.spanLeaf!.duration.subdivisionLevel
                return BeamJunctionOrdFirst(cur: levelCur, next: levelNext)
            }
            if ( // Middle in Container
                cur.spanLeaf!.parent! === prev.spanLeaf!.parent! &&
                cur.spanLeaf!.parent! === next.spanLeaf!.parent!
            ) {
                let levelPrev = prev.spanLeaf!.duration.subdivisionLevel
                let levelNext = next.spanLeaf!.duration.subdivisionLevel
                return BeamJunctionOrdMiddle(prev: levelPrev, cur: levelCur, next: levelNext)
            }
            if ( // Last in Container
                cur.spanLeaf!.parent! === prev.spanLeaf!.parent! &&
                cur.spanLeaf!.parent! !== next.spanLeaf!.parent!
            ) {
                let levelPrev = prev.spanLeaf!.duration.subdivisionLevel
                let levelNext = next.spanLeaf!.duration.subdivisionLevel
                return BeamJunctionExtendedLast(prev: levelPrev, cur: levelCur, next: levelNext)
            }
        }
        // Last
        else if i == array.count - 1 {
            let prev = array[i - 1]
            let cur = array[i]
            let levelCur = cur.spanLeaf!.duration.subdivisionLevel
            // Single last
            if cur.spanLeaf!.parent! === prev.spanLeaf!.parent! {
                let levelPrev = prev.spanLeaf!.duration.subdivisionLevel
                return BeamJunctionOrdLast(prev: levelPrev, cur: levelCur)
            }
            // Last of group
            else { return BeamJunctionOrdSingle(cur: levelCur) }
        }
        return nil
    }    
}