import QuartzCore
import UIKit

/**
PathPoints
*/
class PathPoints {
    
    // MARK: Attributes
    
    /// Starting point of PathPoints
    var start: CGFloat = 0
    
    /// Stopping point of PathPoints
    var stop: CGFloat = 0
    
    // MARK: Create PathPoints
    
    /**
    Create PathPoints with starting point
    
    :param: start Starting point of PathPoints
    
    :returns: Self: PathPoints
    */
    init(start: CGFloat) {
        self.start = start
    }
    
    /**
    Create PathPoints with starting and stopping points
    
    :param: start Starting point of PathPoints
    :param: stop  Stopping point of PathPoints
    
    :returns: Self: PathPoints
    */
    init(start: CGFloat, stop: CGFloat) {
        self.start = start
        self.stop = stop
    }
    
    // MARK: Incrementally build PathPoints
    
    /**
    Set starting point of PathPoints
    
    :param: start Starting point of PathPoints
    */
    func setStart(start: CGFloat) {
        self.start = start
    }
    
    /**
    Set stopping point of PathPoints
    
    :param: stop Stopping point of PathPoints
    */
    func setStop(stop: CGFloat) {
        self.stop = stop
    }
}