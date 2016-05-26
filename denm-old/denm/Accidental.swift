import UIKit
import QuartzCore

/**
Accidental: much discussion needed
*/
class Accidental: CAShapeLayer, StaffSpace {
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Height of Accidental
    var height: CGFloat = 0
    
    /// Width of Accidental
    var width: CGFloat = 0
    
    // MARK: Body Dimensions
    
    /// Width of middle section of body
    var midWidth: CGFloat { get { return 0.618 * g } }
    
    /// Width of flanks (for AccidentalSharp only) // perhaps move this only to AccidentalSharp?
    var flankWidth: CGFloat { get { return 0.1236 * g } }
    
    // MARK: Thin Line Dimensions
    
    /// Width of thinLine
    var thinLineWidth: CGFloat { get { return 0.0875 * g } }
    
    // MARK: Thick Line Dimensions
    
    /// Width of thickLine
    var thickLineWidth: CGFloat { get { return 0.382 * g } }
    
    /// Slope of thickLine
    var thickLineSlope: CGFloat = 0.25
    
    // MARK: Arrow Dimensions
    
    /// Height of arrow
    var arrowHeight: CGFloat { get { return 0.5 * g } }
    
    /// Width of arrow
    var arrowWidth: CGFloat { get { return 0.618 * g } }
    
    /// Inset of arrow barb
    var arrowBarb: CGFloat { get { return 0.236 * g } }
    
    // MARK: Position
    
    /// Top of Accidental
    var top: CGFloat = 0
    
    /// Left of Accidental
    var left: CGFloat = 0
    
    /// Horizontal center of Accidental
    var x: CGFloat = 0
    
    /// Vertical (optical) center of Accidental
    var y: CGFloat = 0
    
    /// Horizontal (optical) center of Accidental in relation to left of Accidental layer
    var xRel: CGFloat = 0
    
    /// Vertical (optical) center of Accidental in relation to right of Accidental layer
    var yRel: CGFloat = 0
    
    /// Staff space of Notehead (relative to top staff space of staff)
    var staffSpace: CGFloat = 0

    // MARK: Components
    
    /**
    Array of points for path to be drawn clockwise around Accidental
    
    Each point Array may contain 1 (point) or 3 (curve) arrays of [x,y] values
    
    More discussion needed
    */
    var outlinePoints = [[[CGFloat]]]()
    
    /**
    Array of points for path to be drawn clockwise around Accidental
    
    Each point Array may contain 1 (point) or 3 (curve) arrays of [x,y] values
    
    More discussion needed
    
    Hole points (if applicable) are drawn last, and cut a hole into middle of Accidental
    */
    var holePoints: ([[[CGFloat]]])?
    
    /// UIBezier path that is incrementally built, then converted to CGPath for CAShapeLayer
    var _path: UIBezierPath = UIBezierPath()
    
    // undocumented for now
    var zones: [AccidentalZone] = []
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build an Accidental
    
    /**
    Set size of Accidental with Graphical height of a single Guidonian staff space
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: Accidental
    */
    func setSize(#g: CGFloat) -> Accidental {
        self.g = g
        setDimensions()
        return self
    }
    
    /**
    Set horizontal center of Accidental
    
    :param: x Horizontal center of Accidental
    
    :returns: Self: Acccidental
    */
    func setX(x: CGFloat) -> Accidental {
        self.x = x
        return self
    }
    
    /**
    Set vertical center of Accidental
    
    :param: y Vertical center of Accidental
    
    :returns: Self: Accident
    */
    func setY(y: CGFloat) -> Accidental {
        self.y = y
        return self
    }
    
    /**
    Set vertical center of Accidental with staff space (relative to top staff line)
    
    :param: staffSpace Staff space (relative to top staff line)
    
    :returns: Self: Accidental
    */
    func setYWithStaffSpace(staffSpace: CGFloat) -> Accidental {
        self.staffSpace = staffSpace
        self.y = -staffSpace * g
        return self
    }
    
    // uncdocumented for now
    func addZone(zone: AccidentalZone) {
        zones.append(zone)
    }
    
    /**
    Add all necessary components to Accidental layer
    
    :returns: Self: Accidental
    */
    func build() -> Accidental {
        setFrame()
        addComponents()
        commitAllPoints()
        setVisualAttributes()
        opaque = true
        return self
    }
    
    internal func commitAllPoints() {
        commitPoints(outlinePoints)
        if holePoints != nil { commitPoints(holePoints!) }
        path = _path.CGPath
    }
    
    internal func addComponents() {
        /* override in each subclass */
    }
    
    internal func addArrow(x: CGFloat, y: CGFloat, dir: CGFloat) {
        outlinePoints.extend([
            [[x - dir * 0.5 * thinLineWidth, y + dir * arrowHeight]],
            [[x - dir * 0.5 * arrowWidth, y + dir * (arrowHeight + arrowBarb)]],
            [[x, y]],
            [[x + dir * 0.5 * arrowWidth, y + dir * (arrowHeight + arrowBarb)]],
            [[x + dir * 0.5 * thinLineWidth, y + dir * arrowHeight]]
        ])
    }
    
    internal func commitPoints(points: [[[CGFloat]]]) {
        for point in points {
            if point.count == 1 {
                
                // first point
                if point == points[0] {
                    _path.moveToPoint(CGPointMake(point[0][0], point[0][1]))
                }
                // rest
                else {
                    _path.addLineToPoint(CGPointMake(point[0][0], point[0][1]))
                }
            }
            else if point.count == 3 {
                _path.addCurveToPoint(CGPointMake(point[0][0], point[0][1]),
                    controlPoint1: CGPointMake(point[1][0], point[1][1]),
                    controlPoint2: CGPointMake(point[2][0], point[2][1])
                )
            }
        }
        _path.closePath()
    }
    
    internal func setOutlinePoints() {
        /* override in each subclass */
    }
    
    internal func setHolePoints() {
        /* override in each subclass */
    }
    
    internal func setThickLineΔY() {
        /* override in each subclass as necessary */
    }
    
    internal func getThickLineYAtX(x: CGFloat, ΔY: CGFloat, dir: CGFloat) -> CGFloat {
        let y: CGFloat = (
            yRel + ΔY +
            thickLineSlope * (xRel - x) +
            dir * 0.5 * thickLineWidth
        )
        return y
    }
    
    internal func setDimensions() {
        setWidth()
        setHeight()
    }
    
    internal func setWidth() {
        
    }
    
    internal func setHeight() {
        
    }
    
    internal func setPoints() {
        
    }
    
    internal func setFrame() {
        top = y - yRel
        left = x - xRel
        frame = CGRectMake(left, top, width, height)
    }
    
    internal func setVisualAttributes() {
        lineWidth = 0
        fillColor = UIColor.blackColor().CGColor
        backgroundColor = UIColor.clearColor().CGColor
        fillRule = kCAFillRuleEvenOdd
    }
    
    override func hitTest(p: CGPoint) -> CALayer! {
        if containsPoint(p) { return self }
        else { return nil }
    }
    
    override func containsPoint(p: CGPoint) -> Bool {
        return CGRectContainsPoint(frame, p)
    }
}