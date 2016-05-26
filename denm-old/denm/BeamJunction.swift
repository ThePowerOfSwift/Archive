/**
BeamJunction
*/
class BeamJunction {
    
    // MARK: Subdivision Levels of Context
    
    /// Level of Subdivision of previous Duration
    var prev: Int = 0
    
    /// Level of Subdivision of current Duration
    var cur: Int = 0
    
    /// Level of Subdivision of next Duration
    var next: Int = 0
    
    /// Beamlet dirction (-1: backward, +1: forward)
    var beamletDirection: Int?
    
    // MARK: Ranges of BeamJunction types
    
    /// Start beams in range
    var startBeamsInRange: [Int] = []
    
    /// End beams in range
    var endBeamsInRange: [Int] = []
    
    /// Beamlets in range
    var beamletsInRange: [Int] = []
    
    /// Extended beams in range
    var extendedInRange: [Int] = []
    
    // MARK: Create a BeamJunction
    
    /**
    Create a BeamJunction with level of Subdivision of current Duration
    
    :param: cur level of Subdivision of current Duration
    
    :returns: Self: BeamJunction
    */
    init(cur: Int) {
        self.cur = cur
    }
    
    // MARK: Analysis
    
    /**
    Get all ranges of Beam types (overriden in all subclasses)
    
    :returns: Array of ranges in order: start, end, beamlets
    */
    func getComponents() -> [[Int]] {
        cleanup()
        return [startBeamsInRange, endBeamsInRange, beamletsInRange]
    }
    
    /**
    Get beamlet direction: make getter
    
    :returns: Int?
    */
    func getBeamletDirection() -> Int? {
        if beamletsInRange != [0,0] { return beamletDirection }
        return nil
    }
    
    /**
    Clean up ranges
    */
    func cleanup() {
        if startBeamsInRange[1] < startBeamsInRange[0] { startBeamsInRange = [0,0] }
        if endBeamsInRange[1] < endBeamsInRange[0] { endBeamsInRange = [0,0] }
        if beamletsInRange[1] < beamletsInRange[0] { beamletsInRange = [0,0] }
        if extendedInRange[1] < extendedInRange[0] { extendedInRange = [0,0] }
    }
}