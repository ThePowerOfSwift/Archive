import UIKit
import QuartzCore

class AccidentalZone {
    
    var components: [AccidentalComponent] = []
    
    var polygon: UIBezierPath = UIBezierPath()
    
    func addComponent(component: AccidentalComponent) {
        components.append(component)
    }
}