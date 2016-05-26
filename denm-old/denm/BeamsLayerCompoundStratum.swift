import UIKit
import QuartzCore

/**
BeamsLayerCompoundStratum
*/
class BeamsLayerCompoundStratum: Stratum {
    
    // MARK: Attributes
    
    /**
    Orientation of BeamGroup
    
    - +1: Stems-down
    - -1: Stems-up
    - +0: Neutral
    */

    var o: CGFloat = 1 // orientation
    
    // MARK: Components
    
    /// References to all BeamsLayerStrata in BeamsLayerCompoundStratum
    var beamsLayerStrata: [BeamsLayerStratum] = []
    
    /**
    Set orientation of BeamsLayerCompoundStratum
    
    :param: orientation Orientation of BeamsLayerCompoundStratum
    
    :returns: Self: BeamsLayerCompoundStratum
    */
    func setOrientation(orientation: CGFloat) -> BeamsLayerCompoundStratum {
        self.o = orientation
        return self
    }
    
    /**
    Add BeamsLayerStratum to BeamsLayerCompoundStratum
    
    :param: beamsLayerStratum BeamsLayerStratum
    
    :returns: Self: BeamsLayerCompoundStratum
    */
    func addBeamsLayerStratum(beamsLayerStratum: BeamsLayerStratum) -> BeamsLayerCompoundStratum {
        beamsLayerStrata.append(beamsLayerStratum)
        return self
    }
    
    /**
    Set size and position of BeamsLayerCompoundStratum
    
    :returns: Self: BeamsLayerCompoundStratum
    */
    func build() -> BeamsLayerCompoundStratum {
        setHeight()
        setFrame()
        return self
    }
    
    func setHeight() {
        var maxHeight: CGFloat = 0
        for stratum in beamsLayerStrata {
            maxHeight = stratum.height > maxHeight ? stratum.height : maxHeight
        }
        height = maxHeight
    }
}