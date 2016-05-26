import QuartzCore
import UIKit

/**
BeamsLayerStratum
*/
class BeamsLayerStratum: Stratum {
    
    // MARK: Attributes
    
    /**
    Orientation of BeamGroup
    
    - +1: Stems-down
    - -1: Stems-up
    - +0: Neutral
    */
    var o: CGFloat = 1
    
    // MARK: Components
    
    /// Reference to all BeamsLayers in BeamsLayerStratum
    var beamsLayers: [BeamsLayer] = []
    
    // MARK: Incrementally build a BeamsLayerStratum
    
    /**
    Set orientation of BeamsLayerStratum
    
    :param: orientation Orientation of BeamsLayerStratum
    
    :returns: Self: BeamsLayerStratum
    */
    func setOrientation(orientation: CGFloat) -> BeamsLayerStratum {
        self.o = orientation
        return self
    }
    
    /**
    Add BeamsLayer to BeamsLayerStratum
    
    :param: beamsLayer BeamsLayer
    
    :returns: Self: BeamsLayerStratum
    */
    func addBeamsLayer(beamsLayer: BeamsLayer) -> BeamsLayerStratum {
        beamsLayers.append(beamsLayer)
        addSublayer(beamsLayer)
        return self
    }
    
    /**
    Set size and position of BeamsLayerStratum
    
    :returns: Self: BeamsLayerStratum
    */
    func build() -> BeamsLayerStratum {
        setHeight()
        setFrame()
        return self
    }
    
    /**
    Overrides Stratum.moveTo(x:y:)
    
    :param: x x-value
    :param: y y-value
    */
    override func moveTo(#x: CGFloat, y: CGFloat) {
       
        /*
        CATransaction.setAnimationDuration(0.125)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        */
        
        for beamsLayer in beamsLayers {
            
            
            beamsLayer.moveTo(x: x, y: y)
            
            // adjust beams!

            for ligature in beamsLayer.bgContainer!.ligatures.ligatures {
                ligature.setBeamEndY(y - ligature.pad).resize()
            }

            // encapsulate
            for leaf in beamsLayer.bgContainer!.leaves {
                leaf.stem?.beamEndY = y
                leaf.stem?.rebuild()
            }
        }
    }
    
    func setHeight() {
        var maxHeight: CGFloat = 0
        for beamsLayer in beamsLayers {
            maxHeight = beamsLayer.height > maxHeight ? beamsLayer.height : maxHeight
        }
        height = maxHeight
    }
    
    override func setExternalPads() {

        
    }
}