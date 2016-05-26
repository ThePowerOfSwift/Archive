import QuartzCore

/**
BeamJunctionOrdFirst: more discussion needed
*/
class BeamJunctionOrdFirst: BeamJunction {
    
    // MARK: Create a BeamJunctionOrdFirst
    
    /**
    Create a BeamJunctionOrdFirst with levels of Subdivision of cur and next Durations
    
    :param: cur  Level of Subdivision of current Duration
    :param: next Level of Subdivision of next Duration
    
    :returns: Self: BeamJunction
    */
    init(cur: Int, next: Int) {
        super.init(cur: cur)
        self.cur = cur
        self.next = next
        beamletDirection = 1
    }
    
    // MARK: Analysis
    
    /**
    Get all ranges of Beam types
    
    :returns: Array of ranges in order: start, end, beamlets, extended
    */
    override func getComponents() -> [[Int]] {
        if cur > next {
            startBeamsInRange = [1, next]
            beamletsInRange = [next + 1, cur]
        }
        else {
            startBeamsInRange = [1, cur]
            beamletsInRange = [0,0]
        }
        endBeamsInRange = [0,0]
        extendedInRange = [0,0]
        
        cleanup()
        return [startBeamsInRange, endBeamsInRange, beamletsInRange, extendedInRange]
    }
}