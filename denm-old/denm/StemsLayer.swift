import QuartzCore
import UIKit

/**
StemsLayer
*/
class StemsLayer: CAShapeLayer {
    
    // MARK: Components
    
    /// All stems in StemsLayer
    var stems: [Stem] = []
    
    // MARK: Size
    
    /// Graphical height of a single Guidonian staff space
    var g: CGFloat = 0
    
    /// Width of StemsLayer
    var width: CGFloat = 0
    
    /// Width of Stems in StemsLayer
    var stemWidth: CGFloat = 0
    
    // MARK: Position
    
    /**
    Orientation of StemsLayer
    
    - +1: Stems-down
    - -1: Stems-up
    - +0: Neutral
    */
    var o: CGFloat = 0 // orientation
    
    // MARK: Create a StemsLayer
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a StemsLayer
    
    /**
    Set size of StemsLayer with Graphical height of a single Guidonian staff space and width
    
    :param: g     Graphical height of a single Guidonian staff space
    :param: width Width of StemsLayer
    */
    func setSize(#g: CGFloat, width: CGFloat) {
        self.g = g
        self.width = width
        self.stemWidth = 0.0618 * g
    }
    
    /**
    Set orientation of StemsLayer
    
    :param: orientation Orientation
    */
    func setOrientation(orientation: Int) {
        self.o = CGFloat(orientation)
    }
    
    /**
    Add stem
    
    :param: stem Stem
    
    :returns: Self: StemsLayer
    */
    func addStem(stem: Stem) -> StemsLayer {
        stems.append(stem)
        addSublayer(stem)
        return self
    }
}