import UIKit
import QuartzCore

/**
ExtensionsLayer: change name to DurationalExtensionsLayer?
*/
class DELayer: CALayer {
    
    // MARK: Components
    
    /// All DurationalExtensions in DurationalExtensionsLayer
    var extensions: [DurationalExtension] = []
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    /**
    Add DurationalExtension
    
    :param: durationalExtension DurationalExtension
    
    :returns: Self: ExtensionsLayer
    */
    func addExtension(durationalExtension: DurationalExtension) -> DELayer {
        
        // set x0, x1 with event info?
        
        extensions.append(durationalExtension)
        return self
    }
}