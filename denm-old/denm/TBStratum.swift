import QuartzCore
import UIKit

/**
TBStratum (Tuplet Bracket Stratum)
*/
class TBStratum: Stratum {
    
    // MARK: Components
    
    /// Reference to TupletBrackets in TBStratum
    var tupletBrackets: [TupletBracket] = []
    
    /// Levels embedded in tuplet
    var depth: Int = 0
    
    // MARK: Create a TBStratum
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a TBStratum
    
    /**
    Set depth of TBStratum
    
    :param: depth levels embdedded in Tuplet
    
    :returns: Self: TBStratum
    */
    func setDepth(depth: Int) -> TBStratum {
        self.depth = depth
        return self
    }
    
    /**
    Set top of TBStratum
    
    :param: top Top of TBStratum
    
    :returns: Self: TBStratum
    */
    func setTop(top: CGFloat) -> TBStratum {
        self.top = top
        return self
    }
    
    /**
    Set height of TBStratum
    
    :param: height Height of TBStratum
    
    :returns: Self: TBStratum
    */
    func setHeight(height: CGFloat) -> TBStratum {
        self.height = height
        return self
    }
    
    /**
    Add TupletBracket to TBStratum
    
    :param: tupletBracket TupletBracket
    
    :returns: Self: TBStratum
    */
    func addTupletBracket(tupletBracket: TupletBracket) -> TBStratum {
        tupletBrackets.append(tupletBracket)
        return self
    }
    
    /**
    Overrides Stratum.moveTo(x:y:)
    
    :param: x x-value
    :param: y y-value
    */
    override func moveTo(#x: CGFloat, y: CGFloat) {
        for tupletBracket in tupletBrackets {
            tupletBracket.position.y = y + 0.5 * tupletBracket.frame.height
            
            // adjust ligatures: encapsulate
            
            for ligature in tupletBracket.container!.ligatures.ligatures {
                if let reintroduce = ligature as? TBLReintroduce {
                    ligature.setBracketEndY(tupletBracket.frame.midY).resize()
                }
                else {
                    ligature.setBracketEndY(tupletBracket.frame.maxY + ligature.pad).resize()
                }
            }
        }
    }
    
    /**
    Build TBStratum (sets frame of layer based on TupletBracket height)
    
    :returns: Self: TBStratum
    */
    func build() -> TBStratum {
        setFrame()
        setExternalPads()
        return self
    }
    
    override func setFrame() {
        height = tupletBrackets[0].height
        frame = CGRectMake(left, top, width, height)
    }
    
    override func setExternalPads() {
        externalPads.setBottom(0.236 * height)
    }

    func hightlight() {
        for tupletBracket in tupletBrackets {
            tupletBracket.highlight()
        }
    }
}