import QuartzCore

/**
StemPathPoints
*/
struct StemPathPoints {
    
    // MARK: Attributes
    
    /// x-value of StemPathPoints
    var x: CGFloat = 0
    
    /// y-value of beamEnd of StemPathPoints
    var beamEnd: CGFloat = 0
    
    /// y-value of infoEnd of StemPathPoints
    var infoEnd: CGFloat = 0
    
    // MARK: Create StemPathPoints
    
    /**
    Create empty StemPathPoints
    
    :returns: Self: StemPathPoints
    */
    init() {}
    
    /**
    Create StemPathPoints with x-value and y-values of beamEnd and infoEnd
    
    :param: x       x-value of StemPathPoints
    :param: beamEnd y-value of beamEnd of StemPathPoints
    :param: infoEnd y-value of infoEnd of StemPathPoints
    
    :returns: Self: StemPathPoints
    */
    init(x: CGFloat, beamEnd: CGFloat, infoEnd: CGFloat) {
        self.x = x
        self.beamEnd = beamEnd
        self.infoEnd = infoEnd
    }
}