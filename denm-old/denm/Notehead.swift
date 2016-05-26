import UIKit
import QuartzCore

/**
Notehead
*/
class Notehead: CAShapeLayer, StaffSpace {
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    // MARK: Position
    
    /// Horizontal center of Notehead
    var x: CGFloat = 0
    
    /// Vertical center of Notehead
    var y: CGFloat = 0
    
    /// Staff space (counted from top staff space of staff) of Notehead
    var staffSpace: CGFloat = 0
    
    // MARK: Visual Attributes
    
    /// Color of Notehead
    var color: CGColor = UIColor.grayColor().CGColor
    
    // MARK: Create a Notehead
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a Notehead
    
    /**
    Set size of Notehead with Graphical height of a single Guidonian staff space
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: Notehead
    */
    func setSize(#g: CGFloat) -> Notehead {
        self.g = g
        return self
    }
    
    /**
    Set horizontal center of Notehead
    
    :param: x Horizontal center of Notehead
    
    :returns: Self: Notehead
    */
    func setX(x: CGFloat) -> Notehead {
        self.x = x
        return self
    }
    
    /**
    Set vertical center of Notehead
    
    :param: y Verical center of Notehead
    
    :returns: Self: Notehead
    */
    func setY(y: CGFloat) -> Notehead {
        self.y = y
        return self
    }
    
    /**
    Set vertical center with staffSpace (relative to top staff space of staff)
    
    :param: staffSpace Staff space of Notehead (relative to top staff space of staff)
    
    :returns: Self: Notehead
    */
    func setYWithStaffSpace(staffSpace: CGFloat) -> Notehead {
        self.staffSpace = staffSpace
        self.y = -staffSpace * g
        return self
    }
    
    /**
    Set position of Notehead with vertical and horizontal centers of Notehead
    
    :param: x Horizontal center of Notehead
    :param: y Vertical center of Notehead
    
    :returns: Self: Beam
    */
    func setPosition(x: CGFloat, y: CGFloat) -> Notehead {
        self.x = x
        self.y = y
        return self
    }
    
    /**
    Set all necessary visual attributes
    
    :returns: Self: Notehead
    */
    func build() -> Notehead { return self }
}