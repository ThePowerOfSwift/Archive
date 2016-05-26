import QuartzCore

/**
BeamJunctionOrdMiddle: more discussion needed
*/
class BeamJunctionOrdMiddle: BeamJunction {
    
    // MARK: Create a BeamJunctionOrdMiddle
    
    /**
    Create a BeamJunctionOrdMiddle with levels of Subdivision in prev, cur, next Durations
    
    :param: prev Level of Subdivision in previous Duration
    :param: cur  Level of Subdivision in current Duration
    :param: next Level of Subdivision in next Duration
    
    :returns: Self: BeamJunction
    */
    init(prev: Int, cur: Int, next: Int) {
        super.init(cur: cur)
        self.prev = prev
        self.cur = cur
        self.next = next
    }
    
    // MARK: Analysis
    
    /**
    Get all ranges of Beam type
    
    :returns: Array of ranges in order: start, end, beamlets, extended
    */
    override func getComponents() -> [[Int]] {
        startBeamsInRange = [0,0]
        endBeamsInRange = [0,0]
        beamletsInRange = [0,0]
        extendedInRange = [0,0]
        if cur > next {
            var lesser = sorted([cur, prev])[0]
            if cur > prev {
                if prev >= next {
                    beamletsInRange = [prev + 1, cur]
                    if prev > next { endBeamsInRange = [next + 1, prev] }
                }
                else if prev < next {
                    startBeamsInRange = [prev + 1, next]
                    beamletsInRange = [next + 1, cur]
                }
            }
            else { endBeamsInRange = [next + 1, lesser] }
        }
        else if cur <= next && cur > prev { startBeamsInRange = [prev + 1, cur] }
        beamletDirection = prev > next ? -1 : 1
        cleanup()
        return [startBeamsInRange, endBeamsInRange, beamletsInRange, extendedInRange]
    }
}