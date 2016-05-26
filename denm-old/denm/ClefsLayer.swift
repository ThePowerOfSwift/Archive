import QuartzCore
import UIKit

/**
ClefsLayer
*/
class ClefsLayer: CALayer {
    
    // MARK: Components
    
    /// All Clefs in ClefsLayer
    var clefs: [Clef] = []
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Height of ClefsLayer
    var height: CGFloat = 0
    
    /// Width of ClefsLayer
    var width: CGFloat = 0
    
    // MARK: Position
    
    /// Top of ClefsLayer
    var top: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a ClefsLayer
    
    /**
    Set size of ClefsLayer with Graphical height of a single Guidonian staff space and height
    
    :param: g      Graphical height of a single Guidonian staff space
    :param: height Height of ClefsLayer
    
    :returns: Self: ClefsLayer
    */
    func setSize(g: CGFloat, height: CGFloat) -> ClefsLayer {
        self.g = g
        self.height = height
        return self
    }
    
    /**
    Set top of ClefsLayer
    
    :param: top Top of ClefsLayer
    
    :returns: Self: ClefsLayer
    */
    func setTop(top: CGFloat) -> ClefsLayer {
        self.top = top
        return self
    }
    
    /**
    Add Clef to ClefsLayer
    
    :param: clef Clef
    
    :returns: Self: ClefsLayer
    */
    func addClef(clef: Clef) -> ClefsLayer {
        clefs.append(clef)
        return self
    }
    
    /**
    Add all necessary components to ClefsLayer
    
    :returns: Self: ClefsLayer
    */
    func build() -> ClefsLayer {
        for clef in clefs {
            clef.setSize(g, height: height)
                .setTop(0)
                .build()
            addSublayer(clef)
        }
        setFrame()
        return self
    }
    
    internal func setFrame() -> ClefsLayer {
        frame = CGRectMake(0, top, width, height)
        return self
    }
    
    internal func setWidth(width: CGFloat) -> ClefsLayer {
        self.width = width
        return self
    }
}