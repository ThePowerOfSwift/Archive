import QuartzCore
import UIKit

/**
TBLigaturesLayer
*/
class TBLigaturesLayer: CALayer {
    
    // MARK: View Context
    
    /// BGContainer (Beam Group Container) containing TBLigaturesLayer
    var bgContainer: BGContainer?
    
    /// Levels embedded in tuplet
    var depth: Int = 0
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Width of TBLigaturesLayer
    var width: CGFloat = 0
    
    /// Height of TBLigaturesLayer
    var height: CGFloat { get { return bottom - top } }
    
    // MARK: Position
    
    /// Top of TBLigaturesLayer
    var top: CGFloat = 0
    
    /// Bottom of TBLigaturesLayer
    var bottom: CGFloat = 0
    
    /// Orientation of TBLigaturesLayer
    var o: CGFloat = 1
    
    // MARK: Components

    /// Collection of TBLigatures (Tuplet Bracket Ligatures) contained by TBLigaturesLayer
    var ligatures: [TBLigature] = []
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a TBLigaturesLayer
    
    /**
    Set BGContainer (Beam Group Container of TBLigatures Layer)
    
    :param: bgContainer BGContainer
    
    :returns: Self: TBLigaturesLayer
    */
    func setBGContainer(bgContainer: BGContainer) -> TBLigaturesLayer {
        self.bgContainer = bgContainer
        return self
    }
    
    /**
    Set Depth of TBLigaturesLayer
    
    :param: depth Levels embdedded in tuplet
    
    :returns: Self: TBLigaturesLayer
    */
    func setDepth(depth: Int) -> TBLigaturesLayer {
        self.depth = depth
        return self
    }
    
    /**
    Set size of TBLigaturesLayer
    
    :param: g Graphical height of a single Guidonian staff space
    
    :returns: Self: TBLigaturesLayer
    */
    func setSize(#g: CGFloat) -> TBLigaturesLayer {
        self.g = g
        return self
    }
    
    /**
    Set width of TBLigaturesLayer
    
    :param: width Width of TBLigaturesLayer
    
    :returns: Self: TBLigaturesLayer
    */
    func setWidth(width: CGFloat) -> TBLigaturesLayer {
        self.width = width
        return self
    }
    
    /**
    Set top of TBLigaturesLayer
    
    :param: top Top of TBLigaturesLayer
    
    :returns: Self: TBLigaturesLayer
    */
    func setTop(top: CGFloat) -> TBLigaturesLayer {
        self.top = top
        return self
    }
    
    /**
    Set bottom of TBLigaturesLayer
    
    :param: bottom Bottom of TBLigaturesLayer
    
    :returns: Self: TBLigaturesLayer
    */
    func setBottom(bottom: CGFloat) -> TBLigaturesLayer {
        self.bottom = bottom
        return self
    }
    
    func addLigatureWithID(ID: String, x: CGFloat) {
        var ID = ID
        var y: CGFloat = 0
        clarifyLigatureIDAndY(&ID, y: &y, x: x)
        let ligature: TBLigature = CreateTBLigature().withID(ID)!
            .setSize(g: g)
            .setX(x)
            .setBracketEndY(y)
            .setBeamEndY(height)
            .build()
        ligatures.append(ligature)
    }
    
    internal func clarifyLigatureIDAndY(inout ID: String, inout y: CGFloat, x: CGFloat) {
        if ID == "reintroduce" {
            if tupletBracketMiddleCollidesWithX(x) { ID = "reintroduceTruncated"; y = 10 }
            else { y = -0.5 * bgContainer!.tupletBracket.frame.height }
        }
    }
    
    func tupletBracketMiddleCollidesWithX(x: CGFloat) -> Bool {
        //let circleRadius = 0.41 * g
        let tupletBracket = bgContainer!.tupletBracket
        let left = tupletBracket.textLeft.frame.minX - tupletBracket.padX
        let right = tupletBracket.textRight.frame.maxX + tupletBracket.padX
        return x > left && x < right
    }
    
    func resize() {
        setFrame()
        for ligature in ligatures { ligature.resize() }
    }
    
    func build() -> TBLigaturesLayer {
        commitLigatures()
        resize()
        return self
    }
    
    func commitLigatures() {
        for ligature in ligatures { bgContainer!.addSublayer(ligature) }
    }

    func setFrame() -> TBLigaturesLayer {
        frame = CGRectMake(0, top, width, height)
        return self
    }
}