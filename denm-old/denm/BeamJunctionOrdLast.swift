import QuartzCore

/**
BeamJunctionOrdLast: more discussion needed
*/
class BeamJunctionOrdLast: BeamJunction {
    
    // MARK: Create a BeamJunctionOrdLast
    
    /**
    Create BeamJunctionOrdLast
    
    :param: prev Level of subdivision of previous Duration
    :param: cur  Level of subdivision of current Duration
    
    :returns: Self: BeamJunction
    */
    init(prev: Int, cur: Int) {
        super.init(cur: cur)
        self.prev = prev
        self.cur = cur
        beamletDirection = -1
    }
    
    // MARK: Analysis
    
    /**
    Get all ranges of Beam types
    
    :returns: Array of ranges in order: start, end, beamlets, extended
    */
    override func getComponents() -> [[Int]] {
        if cur > prev {
            endBeamsInRange = [1, prev]
            beamletsInRange = [prev + 1, cur]
        }
        else {
            endBeamsInRange = [1, cur]
            beamletsInRange = [0,0]
        }
        startBeamsInRange = [0,0]
        extendedInRange = [0,0]
        
        cleanup()
        return [startBeamsInRange, endBeamsInRange, beamletsInRange, extendedInRange]
    }
}