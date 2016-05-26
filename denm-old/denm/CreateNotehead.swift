import UIKit
import QuartzCore

/**
Notehead factory

Types (to be developed!):

- ord (standard notehead, rotated ellipse)
- harmonic (backgroundColor-filled diamond)
*/
class CreateNotehead {
    
    /**
    :param: type ord, harmonic (more to come)
    
    :returns: Notehead (as subclass of desired type)
    */
    func withType(type: String) -> Notehead? {
        if type == "ord" { return OrdNotehead()! }
        if type == "harmonic" { return HarmonicNotehead()! }
        return nil
    }
}