import UIKit
import QuartzCore

class DMCharacter_p: DMCharacter {
    
    var serifLength: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    override func addComponents() -> DMCharacter {
        addBowl()
        addStemStroke()
        addSerif()
        return self
    }

    func addSerif() -> DMCharacter_p {
        line.moveToPoint(CGPointMake(0, restLine))
        line.addLineToPoint(CGPointMake(serifLength, restLine))
        return self
    }
    
    func addStemStroke() -> DMCharacter_p {
        line.moveToPoint(CGPointMake(0.5 * serifLength, restLine))
        line.addLineToPoint(CGPointMake(0.618 * width, xHeight))
        line.addLineToPoint(CGPointMake(0.33 * width, xHeight + 0.0618 * height))
        return self
    }
    
    func addBowl() -> DMCharacter_p {
        
        // FOR TESTING ONLY!
        // THIS IS A FILLER, and looks ridiculous: to be recalculated later!
        line = UIBezierPath(ovalInRect:
            CGRectMake(0.5 * width, midLine - 0.25 * width, 0.5 * width, 0.5 * width)
        )
        /*line.addArcWithCenter(
            CGPointMake(0.75 * width, midLine),
            radius: 0.25 * width,
            startAngle: 0,
            endAngle: 360,
            clockwise: true
        )*/
        
        
        //borderWidth = 1
        //borderColor = UIColor.orangeColor().CGColor
        return self
    }
    
    override func setWidth() -> DMCharacter {
        width = baseline - xHeight
        serifLength = 0.382 * width
        return self
    }
    
    override func setKerningKey() {
        kerningKey = "p"
    }
}