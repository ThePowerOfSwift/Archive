import UIKit
import QuartzCore

class Stem: CALayer {
    
    var x: CGFloat = 0
    var beamEndY: CGFloat = 0
    var infoEndY: CGFloat = 0
    var width: CGFloat = 0
    var color: CGColor = UIColor.blackColor().CGColor // make refined later
   
    var stemLine: StemLine = StemLine()
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    func setX(x: CGFloat) -> Stem {
        self.x = x
        return self
    }
    
    func setBeamEndY(beamEndY: CGFloat) -> Stem {
        self.beamEndY = beamEndY
        return self
    }
    
    func setInfoEndY(infoEndY: CGFloat) -> Stem {
        self.infoEndY = infoEndY
        return self
    }
    
    func setWidth(width: CGFloat) -> Stem {
        self.width = width
        return self
    }
    
    func setColor(color: CGColor) -> Stem {
        self.color = color
        return self
    }
    
    func build() -> Stem {
        setFrame()
        addStemLine()
        return self
    }
    
    // establish correct setting of Top and Bottom
    func addStemLine() {
        let height: CGFloat = getHeightForStemLine()
        stemLine.setX(0)
            .setTop(0)
            .setBottom(height) // getHeight from BeamEndY, InfoEndY?
            .setWidth(width)
            .setColor(color)
            .build()
        addSublayer(stemLine)
    }
    
    func getHeightForStemLine() -> CGFloat {
        let height: CGFloat = infoEndY - beamEndY
        return height
    }

    func setFrame() {
        frame = CGRectMake(x, beamEndY, 0, 0)
    }

    func getTopAndHeight() -> (top: CGFloat, height: CGFloat) {
        var top: CGFloat = 0
        var height: CGFloat = 0
        return (top: top, height: height)
    }
    
    func rebuild() -> Stem {
        let height: CGFloat = getHeightForStemLine()
        setFrame()
        stemLine.setBottom(height).rebuild()
        return self
    }
    
    func makePath() -> CGPath {
        let _path: UIBezierPath = UIBezierPath()
        _path.moveToPoint(CGPointMake(x, beamEndY))
        _path.addLineToPoint(CGPointMake(x, infoEndY))
        return _path.CGPath
    }
}