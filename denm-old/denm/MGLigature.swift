import QuartzCore
import UIKit

/**
MGLigature (Metronome Graphic Ligature)
*/
class MGLigature: CAShapeLayer {
    
    // MARK: Attributes
    
    /// Levels embdedded in MetronomeSpanTree
    var depth: Int = 0
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    var length: CGFloat = 0
    
    
    // MARK: Position
    
    var left: CGFloat = 0
    
    var altitude: CGFloat = 0
    
    var color: CGColor = UIColor.lightGrayColor().CGColor


    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) {super.init(coder: aDecoder) }
    override init(layer: AnyObject) { super.init(layer: layer) }
    override init() { super.init() }
    
    /**
    Set depth of MGLigature
    
    :param: depth Levels embdedded in MetronomeSpanTree
    
    :returns: Self: MGLigature
    */
    func setDepth(depth: Int) -> MGLigature {
        self.depth = depth
        return self
    }
    
    /**
    Set size with Graphical height of a single Guidonian staff space
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: MGLigature
    */
    func setSize(#g: CGFloat) -> MGLigature {
        self.g = g
        return self
    }
    
    func setLength(length: CGFloat) -> MGLigature {
        self.length = length
        return self
    }
    
    func setAltitude(altitude: CGFloat) -> MGLigature {
        self.altitude = altitude
        return self
    }
    
    func setColor(color: CGColor) -> MGLigature {
        self.color = color
        return self
    }
    
    func build() -> MGLigature {
        path = makePath()
        setVisualAttributes()
        return self
    }
    
    func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(0, altitude))
        path.addLineToPoint(CGPointMake(length, altitude))
        return path.CGPath
    }
    
    func setVisualAttributes() {
        lineWidth = 1
        strokeColor = color
    }
}