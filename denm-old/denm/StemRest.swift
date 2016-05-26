import UIKit
import QuartzCore

class StemRest: Stem {
    
    // orientation?
    var stemletLength: CGFloat = 0
    var stemLineRest: StemLineRest = StemLineRest()
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    func setStemletLength(stemletLength: CGFloat) -> Stem {
        self.stemletLength = stemletLength
        return self
    }
    
    override func build() -> StemRest {
        setFrame()
        addStemLine()
        addStemLineRest()
        // tell component to do their thing; add sublayers
        return self
    }
    
    override func addStemLine() {
        stemLine.setX(0)
            .setTop(0)
            .setBottom(stemletLength)
            .setWidth(width)
            .setColor(color)
            .build()
        addSublayer(stemLine)
    }
    
    func addStemLineRest() {
        let height: CGFloat = getHeightForStemLine() - stemletLength
        stemLineRest.setX(0)
            .setTop(stemletLength) // add gap, adjust for orientation == -1
            .setBottom(infoEndY) // for testing only
            .setWidth(width)
            .setColor(color)
            .build()
        addSublayer(stemLineRest)
    }
    
    override func rebuild() -> StemRest {
        setFrame()
        stemLine.setBottom(stemletLength).rebuild()
        return self
    }
}