import UIKit
import QuartzCore

class MeasureNumberStratum: Stratum {
    
    var system: System?
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    func setSystem(system: System) -> MeasureNumberStratum {
        self.system = system
        return self
    }
    
    func setSize(height: CGFloat) -> MeasureNumberStratum {
        self.height = height
        setExternalPads()
        return self
    }
    
    func setPosition(left: CGFloat, top: CGFloat) -> MeasureNumberStratum {
        self.left = left
        self.top = top
        return self
    }
    
    func addMeasureNumberWithNumber(number: Int, x: CGFloat, measure: Measure)
        -> MeasureNumberStratum {
        let measureNumber: MeasureNumber = MeasureNumber()
            .setMeasure(measure)
            .setNumber(number)
            .setSize(height)
            .setPosition(x, top: 0)
            .build()
        objects.append(measureNumber)
        return self
    }
    
    func build() -> MeasureNumberStratum {
        setFrame()
        for object in objects { addSublayer(object) }
        return self
    }
    
    override func setExternalPads() {
        externalPads.setBottom(0.1618 * height)
    }
}