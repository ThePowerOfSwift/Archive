import UIKit
import QuartzCore

/**
SubdivisionGraphic
*/
class SubdivisionGraphic: CALayer {
    
    // MARK: Attributes
    
    /// Amount of beams on SubdivisionGraphic
    var amountBeams: Int = 0
    
    // MARK: Size
    
    /// Height of SubdivisionGraphic
    var height: CGFloat = 0
    
    /// Width of SubdivisionGraphic
    var width: CGFloat = 0
    
    /// Width of beams on SubdivisionGraphic
    var beamWidth: CGFloat = 0
    
    /// Displacement of each beam to the next
    var beamΔY: CGFloat = 0
    
    // MARK: Position
    
    /// Horizontal-center x-value of SubdivisionGraphic
    var centerX: CGFloat = 0
    
    /// Vertical-center y-value of SubdivisionGraphic
    var centerY: CGFloat = 0
    
    /// Left of SubdivisionGraphic layer
    var left: CGFloat = 0
    
    /**
    Orientation of SubdivisionGraphic
    
    - +1: Stem-down
    - -1: Stem-up
    - +0: Neutral
    */
    var o: CGFloat = 1
    
    // MARK: Visual Attributes
    
    /// Color of SubdivisionGraphic
    var color: CGColor = UIColor.grayColor().CGColor
    
    // MARK: Sublayers
    
    /// Stem of SubdivisionGraphic
    var stem: CAShapeLayer = CAShapeLayer()
    
    /// Beams of SubdivisionGraphic
    var beams: CAShapeLayer = CAShapeLayer()
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(layer: AnyObject!) { super.init(layer: layer) }
    override init() { super.init() }
    
    // MARK: Incrementally build a SubdivisionGraphic
    
    /**
    Set amount of beams in SubdivisionGraphic
    
    :param: amountBeams Amount of beams in SubdivisionGraphic
    
    :returns: Self: SubdivisionGraphic
    */
    func setInfo(amountBeams: Int) -> SubdivisionGraphic {
        self.amountBeams = amountBeams
        return self
    }
    
    /**
    Set size of SubdivisionGraphic with height
    
    :param: height Height of SubdivisionGraphic
    
    :returns: Self: SubdivisionGraphic
    */
    func setSize(height: CGFloat) -> SubdivisionGraphic {
        self.height = height
        width = 0.382 * height // make getter
        return self
    }
    
    /**
    Set position of SubdivisionGraphic
    
    :param: centerX Horizontal-center x-value of SubdivisionGraphic
    :param: centerY Veritical-center y-value of SubdivisionGraphic
    
    :returns: Self: SubdivisionGraphic
    */
    func setPosition(centerX: CGFloat, centerY: CGFloat) -> SubdivisionGraphic {
        self.centerX = centerX
        self.centerY = centerY
        left = centerX - 0.5 * width
        return self
    }
    
    /**
    Set orientation of SubdivisionGraphic
    
    :param: orientation Orientation of SubdivisionGraphic
    
    :returns: Self: SubdivisionGraphic
    */
    func setOrientation(orientation: CGFloat) -> SubdivisionGraphic {
        self.o = orientation
        return self
    }
    
    /**
    Set color of SubdivisionGraphic
    
    :param: color CGColor
    
    :returns: SubdivisionGraphic
    */
    func setColor(color: CGColor) -> SubdivisionGraphic {
        self.color = color
        return self
    }
    
    /**
    Add all necessary components to SubdivisionGraphic layer
    
    :returns: Self: SubdivisionGraphic
    */
    func build() -> SubdivisionGraphic {
        opaque = true
        setFrame()
        addStem()
        addBeams()
        return self
    }
    
    private func addStem() {
        let path: UIBezierPath = UIBezierPath()
        let stemWidth = 0.0382 * height
        let x: CGFloat = o > 0 ? 0.5 * stemWidth : width - 0.5 * stemWidth
        path.moveToPoint(CGPointMake(x, 0))
        path.addLineToPoint(CGPointMake(x, height))
        stem.path = path.CGPath
        stem.strokeColor = color
        stem.lineWidth = stemWidth
        self.addSublayer(stem)
    }
    
    private func addBeams() {
        setBeamWidth()
        setBeamΔY()
        var path: UIBezierPath = UIBezierPath()
        var beamsInitY: CGFloat = o > 0 ? 0.5 * beamWidth : height - 0.5 * beamWidth
        for b in 0..<amountBeams {
            var y: CGFloat = beamsInitY + CGFloat(b) * o * beamΔY
            path.moveToPoint(CGPointMake(0, y))
            path.addLineToPoint(CGPointMake(width, y))
        }
        beams.path = path.CGPath
        beams.strokeColor = color
        beams.lineWidth = beamWidth
        self.addSublayer(beams)
    }
    
    private func setBeamWidth() {
        beamWidth = (0.25 - 0.0382 * CGFloat(amountBeams)) * height
    }
    
    private func setBeamΔY() {
        beamΔY = (0.382 - (0.0382 * CGFloat(amountBeams))) * height
    }
    
    private func setFrame() {
        frame = CGRectMake(
            left,
            centerY - 0.5 * height,
            width,
            height
        )
    }
}