import QuartzCore

/**
BeamJunctionExtendedLast: more discussion needed
*/
class BeamJunctionExtendedLast: BeamJunction {
    
    // MARK: Create a BeamJunctionExtendedLast
    
    /**
    Create a BeamJunctionExtendedLast with levels of Subdivision of prev, cur, next events
    
    :param: prev Level of Subdivision of previous Duration
    :param: cur  Level of Subdivision of current Duration
    :param: next Level of Subdivision of next Duration
    
    :returns: Self: BeamJunction
    */
    init(prev: Int, cur: Int, next: Int) {
        super.init(cur: cur)
        self.prev = prev
        self.cur = cur
        self.next = next
        beamletDirection = -1
    }
    
    // MARK: Analysis
    
    /**
    Get all ranges of Beam types
    
    :returns: Array of ranges in order: start, end, beamlets, extended
    */
    override func getComponents() -> [[Int]] {
        extendedInRange = [0,0]
        if cur > prev {
            endBeamsInRange = [1, prev]
            beamletsInRange = [prev + 1, cur]
        }
        else {
            if cur < next {
                extendedInRange = cur > 0 ? [1, cur] : [0,0]
                endBeamsInRange = [0,0]
                beamletsInRange = [0,0]
            }
            else if cur == next {
                extendedInRange = cur > 0 ? [1, cur - 1] : [0,0]
                endBeamsInRange = [next - 1, cur]
                beamletsInRange = [0,0]
            }
            else {
                endBeamsInRange = [next + 1, cur]
                extendedInRange = [1, next]
                beamletsInRange = [0,0]
            }
        }
        startBeamsInRange = [0,0]
        cleanup()
        return [startBeamsInRange, endBeamsInRange, beamletsInRange, extendedInRange]
    }
}