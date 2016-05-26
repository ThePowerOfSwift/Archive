import QuartzCore

/**
BeamJunctionExtendedSingle: more discussion needed
*/
class BeamJunctionExtendedSingle: BeamJunction {
    
    // MARK: Create a BeamJunctionExtendedSingle
    
    /**
    Create a BeamJunctionSingle with level of Subdivision of current Duration
    
    :param: cur Level of Subdivision of current Duration
    
    :returns: Self: BeamJunction
    */
    override init(cur: Int) {
        super.init(cur: cur)
        self.cur = cur
        beamletDirection = 1
    }
    
    // MARK: Analysis
    
    /**
    Get all ranges of Beam types
    
    :returns: Array of ranges in order: start, end, beamlets, extended
    */
    override func getComponents() -> [[Int]] {
        startBeamsInRange = [0,0]
        endBeamsInRange = [0,0]
        beamletsInRange = [1, cur]
        extendedInRange = [0,0]
        
        cleanup()
        return [startBeamsInRange, endBeamsInRange, beamletsInRange, extendedInRange]
    }
}