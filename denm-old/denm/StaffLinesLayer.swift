import QuartzCore
import UIKit

/**
StaffLinesLayer
*/
class StaffLinesLayer: GraphLinesLayer {
    
    // MARK: Components
    
    /// All staff line PathPoints on given level
    var staffLinePathPointsOnLevel = Dictionary<Int, [PathPoints]>()
    
    /// All ledger line PathPoints on given level
    var ledgerLinePathPointsOnLevel = Dictionary<Int, [PathPoints]>()
    
    // MARK: Sublayers
    
    /// Layer containing all StaffLines
    var staffLinesLayer: CAShapeLayer = CAShapeLayer()
    
    /// Layer container all LedgerLines
    var ledgerLinesLayer: CAShapeLayer = CAShapeLayer()
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Width of StaffLines
    var staffLineWidth: CGFloat = 0
    
    /// Width of LedgerLines
    var ledgerLineWidth: CGFloat = 0
    
    /// Length of LedgerLines
    var ledgerLineLength: CGFloat = 0
    
    // MARK: Visual Attributes
    
    /// Color of Lines
    var color: CGColor = UIColor.grayColor().CGColor
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createStaffLinePathPointsForAllLevels()
    }
    override init() {
        super.init()
        createStaffLinePathPointsForAllLevels()
    }
    override init(layer: AnyObject) {
        super.init(layer: layer)
        createStaffLinePathPointsForAllLevels()
    }

    // MARK: Incrementally build a StaffLinesLayer
    
    /**
    Set size with Graphical height of a single Guidonian staff space
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: StaffLinesLayer
    */
    func setSize(g: CGFloat) -> StaffLinesLayer {
        self.g = g
        self.staffLineWidth = 0.0618 * g // make getter
        self.ledgerLineWidth = 1.618 * staffLineWidth // make getter
        self.ledgerLineLength = 2 * g // make getter
        return self
    }

    /**
    Start StaffLines at desired x-value
    
    :param: x x-value
    
    :returns: Self: StaffLinesLayer
    */
    override func startLinesAt(#x: CGFloat) -> StaffLinesLayer {
        startStaffLinesAt(x: x)
        return self
    }
    
    /**
    Stop StaffLines at desired x-value
    
    :param: x x-value
    
    :returns: Self: StaffLinesLayer
    */
    override func stopLinesAt(#x: CGFloat) -> StaffLinesLayer {
        stopStaffLinesAt(x: x)
        return self
    }
    
    /**
    Add LedgerLine on level at desired x-value
    
    :param: level Amount of staff lines above or below staff
    :param: x     x-value
    
    :returns: Self: StaffLinesLayer
    */
    func ledgerLineOnLevel(level: Int, x: CGFloat) -> StaffLinesLayer {
        let pathPoints: PathPoints = PathPoints(
            start: x - 0.5 * ledgerLineLength,
            stop: x + 0.5 * ledgerLineLength
        )
        ensureLinePathPointsOnLevel(level)
        ledgerLinePathPointsOnLevel[level]!.append(pathPoints)
        return self
    }
    
    /**
    Add all necessary components to StaffLinesLayer
    
    :returns: Self: StaffLinesLayer
    */
    override func build() -> StaffLinesLayer {
        addStaffLines()
        addLedgerLines()
        return self
    }
    
    internal func startStaffLinesAt(#x: CGFloat) -> StaffLinesLayer {
        for level in 0..<5 { staffLinePathPointsOnLevel[level]!.append(PathPoints(start: x)) }
        return self
    }
    
    internal func stopStaffLinesAt(#x: CGFloat) -> StaffLinesLayer {
        for level in 0..<5 { staffLinePathPointsOnLevel[level]!.last!.stop = x }
        return self
    }
    
    internal func createStaffLinePathPointsForAllLevels() {
        for level in 0..<5 { staffLinePathPointsOnLevel[level] = [] }
    }
    
    internal func addStaffLines() -> StaffLinesLayer {
        let path: UIBezierPath = UIBezierPath()
        for (i, level) in staffLinePathPointsOnLevel {
            
            var pathPointsSorted = level
            pathPointsSorted.sort { $0.start < $1.start }
            
            let y: CGFloat = CGFloat(i) * g
            for pathPoints in pathPointsSorted {
                path.moveToPoint(CGPointMake(pathPoints.start, y))
                path.addLineToPoint(CGPointMake(pathPoints.stop, y))
            }
        }
        staffLinesLayer.path = path.CGPath
        staffLinesLayer.lineWidth = staffLineWidth
        staffLinesLayer.strokeColor = color
        addSublayer(staffLinesLayer)
        return self
    }
    
    internal func ensureLinePathPointsOnLevel(level: Int) {
        if ledgerLinePathPointsOnLevel[level] == nil { ledgerLinePathPointsOnLevel[level] = [] }
    }
    
    internal func addLedgerLines() -> StaffLinesLayer {
        let path: UIBezierPath = UIBezierPath()
        for (i, level) in ledgerLinePathPointsOnLevel {
            let y: CGFloat = i < 0 ? CGFloat(4 - i) * g : -CGFloat(i) * g
            for pathPoints in level {
                path.moveToPoint(CGPointMake(pathPoints.start, y))
                path.addLineToPoint(CGPointMake(pathPoints.stop, y))
            }
        }
        ledgerLinesLayer.path = path.CGPath
        ledgerLinesLayer.lineWidth = ledgerLineWidth
        ledgerLinesLayer.strokeColor = color
        addSublayer(ledgerLinesLayer)
        return self
    }
}