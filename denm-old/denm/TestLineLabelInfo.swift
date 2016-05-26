import UIKit
import QuartzCore

struct TestLineLabelInfo {
    
    var positionValue: CGFloat
    var x: CGFloat
    var top: CGFloat
    var description: String
    
    init(positionValue: CGFloat, x: CGFloat, top: CGFloat, description: String) {
        self.positionValue = positionValue
        self.x = x
        self.top = top
        self.description = description
    }
}