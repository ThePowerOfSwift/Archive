import UIKit

class Slur: CAShapeLayer {
    
    var startPoint: CGPoint = CGPointZero
    var endPoint: CGPoint = CGPointZero
    var apexPoint: CGPoint = CGPointZero
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    /**
    Set start point of Slur
    
    :param: point Start point of Slur
    
    :returns: Self: Slur
    */
    func setStartPoint(point: CGPoint) -> Slur {
        self.startPoint = point
        return self
    }
    
    /**
    Set end point of Slur
    
    :param: point End point of Slur
    
    :returns: Self: Slur
    */
    func setEndPoint(point: CGPoint) -> Slur {
        self.endPoint = point
        return self
    }
    
    /**
    Set apex point of Slur
    
    :param: point Apex point of Slur
    
    :returns: Self: Slur
    */
    func setApexPoint(point: CGPoint) -> Slur {
        self.apexPoint = point
        return self
    }
    
    /**
    Add path, set visual attributes to Slur
    
    :returns: Self: Slur
    */
    func build() -> Slur {
        path = makePath()
        setVisualAttributes()
        return self
    }
    
    private func makePath() -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        let cp1 = CGPointMake(startPoint.x, apexPoint.y)
        let cp2 = CGPointMake(endPoint.x, apexPoint.y)
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)
        return path.CGPath
    }
    
    private func setVisualAttributes() {
        lineWidth = 1
        strokeColor = UIColor.blackColor().CGColor
        fillColor = UIColor.clearColor().CGColor
    }
}