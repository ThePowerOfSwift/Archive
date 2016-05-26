import QuartzCore
import UIKit

/**
Stratum
*/
class Stratum: CALayer {

    // MARK: Hierarchical Context
    
    /// Stratum that contains Stratum
    var container: StratumContainer?
    
    // MARK: Size
    
    /// Height of Stratum
    var height: CGFloat = 0
    
    /// Width of Stratum
    var width: CGFloat = 0
    
    // MARK: Position
    
    /// Left of Stratum
    var left: CGFloat = 0
    
    /// Top of Stratum
    var top: CGFloat = 0
    
    // MARK: Components
    
    // Top, Left, Right, Bottom pads (each having a frame)
    var externalPads: ExternalPads = ExternalPads()
    
    // Array of StratumObjects
    var objects: [StratumObject] = []
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() {
        super.init()
        drawsAsynchronously = true
    }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a Stratum
    
    func addObject(object: StratumObject) {
        objects.append(object)
    }
    
    /**
    Sets the StratumContainer of Stratum
    
    :param: container Stratum containing Stratum
    
    :returns: Self: Stratum
    */
    func setContainer(container: StratumContainer) -> Stratum {
        self.container = container
        return self
    }
    
    /**
    Remove Stratum from StratumContainer
    */
    func removeFromContainer() {
        if container != nil { container!.removeStratum(self) }
    }
    
    func moveTo(#x: CGFloat, y: CGFloat) {
        CATransaction.setAnimationDuration(0.125)
        if superlayer == nil { CATransaction.setDisableActions(true) }
        position.y = y + 0.5 * frame.height
        CATransaction.setDisableActions(false)
    }
    
    func setFrame() {
        /* override if necessary */
        setWidth()
        frame = CGRectMake(left, top, width, height)
    }
    
    func setWidth() -> Stratum {
        /* override if necessary */
        var maxWidth: CGFloat = 0
        for object in objects {
            maxWidth = object.position.x > maxWidth ? object.position.x : maxWidth
        }
        width = maxWidth
        return self
    }

    func setExternalPads() { /* override */ }
}