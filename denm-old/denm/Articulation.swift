import UIKit
import QuartzCore

/**
Articulation:

- staccato
- staccatissimo
- martellato
- tenuto
- accent
- compound articulations: tenuto/staccato, tenuto/accent, etc
- trill
- tremolo
- mordent
- mordent inverted
- turn
- double- / triple-tongueing
- perhaps more contemporary techniques (jete, etc)
- ! NO SLUR HERE, that is its own beast

*/
class Articulation: CAShapeLayer {
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    // MARK: Position
    
    /// x-value of Articulation
    var x: CGFloat = 0
    
    /// y-value of Articulation
    var y: CGFloat = 0
    
    /**
    Orientation of BeamGroup
    
    - +1: above object
    - -1: below object
    */
    var o: CGFloat = 0 // orientation (1: above object, -1: below object)
    
    // MARK: Visual Attributes
    
    var color: CGColor = UIColor.blackColor().CGColor
    
    // MARK: Create a Articulation
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build an Articulation
    
    /**
    Set size of Articulation with Graphical height of a single Guidonian staff space
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: Articulation
    */
    func setSize(#g: CGFloat) -> Articulation {
        self.g = g
        lineWidth = 0.1236 * g
        return self
    }
    
    /**
    Set horizontal center of Articulation
    
    :param: x Horizontal center of Articulation
    
    :returns: Self: Articulation
    */
    func setX(x: CGFloat) -> Articulation {
        self.x = x
        return self
    }
    
    /**
    Set vertical center of Articulation
    
    :param: y Vertical center of Articulation
    
    :returns: Self: Articulation
    */
    func setY(y: CGFloat) -> Articulation {
        self.y = y
        return self
    }
    
    /**
    Set orientation of Articulation
    
    :param: orientation Orientation of Articulation
    
    :returns: Self: Articulation
    */
    func setOrientation(orientation: CGFloat) -> Articulation {
        self.o = orientation
        return self
    }
    
    /**
    Add all necessary components to Articulation Layer
    
    :returns: Self: Articulation
    */
    func build() -> Articulation {
        path = makePath()
        setVisualAttributes()
        return self
    }
    
    internal func setVisualAttributes() {
        
    }
    
    internal func makePath() -> CGPath {
        /* override in each subclass */
        let path: UIBezierPath = UIBezierPath()
        return path.CGPath
    }
    
    internal func addComponents() -> Articulation {

        return self
    }
    
    internal func setFrame() -> Articulation {
    
        return self
    }
}