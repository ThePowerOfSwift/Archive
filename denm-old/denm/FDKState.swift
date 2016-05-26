import UIKit
import QuartzCore

class FDKState {
    
    // subclass for: Active, Idle, TrillFull, TrillHalf
    
    var key: FDKey
    
    init(key: FDKey) {
        self.key = key
    }
}