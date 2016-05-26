import UIKit
import QuartzCore

/**
ClefEmpty
*/
class ClefEmpty: StaffClef {
    
    /**
    Add all necessary components to ClefEmpty layer
    
    :returns: Self: Clef
    */
    override func build() -> Clef {
        setFrame()
        addTranspositionLabel()
        return self
    }
}