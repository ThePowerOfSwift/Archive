import QuartzCore

/**
BeamPathPoints
*/
struct BeamPathPoints {
    
    // MARK: Attributes
    
    /// Horizontal starting point of BeamPathPoints
    var start: CGFloat = 0
    
    /// Horizontal ending point of BeamPathPoints
    var end: CGFloat = 0
    
    // MARK: Create BeamPathPoints
    
    /**
    Create empty BeamPathPoints
    
    :returns: Self: BeamPathPoints
    */
    init() {}
    
    /**
    Create BeamPathPoints with starting point and ending point
    
    :param: start Horizontal starting point of BeamPathPoints
    :param: end   Horizontal ending point of BeamPathPoints
    
    :returns: Self: BeamPathPoints
    */
    init(start: CGFloat, end: CGFloat) {
        self.start = start
        self.end = end
    }
}