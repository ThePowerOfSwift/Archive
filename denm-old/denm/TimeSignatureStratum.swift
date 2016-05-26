import UIKit
import QuartzCore

class TimeSignatureStratum: Stratum {

    // MARK: View Context
    
    var system: System?
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init() { super.init() }
    override init(layer: AnyObject) { super.init(layer: layer) }
    
    func setSystem(system: System) -> TimeSignatureStratum {
        self.system = system
        return self
    }
    
    func setSize(height: CGFloat) -> TimeSignatureStratum {
        self.height = height
        setExternalPads()
        return self
    }
    
    func setPosition(left: CGFloat, top: CGFloat) -> TimeSignatureStratum {
        self.left = left
        self.top = top
        return self
    }
    
    func addTimeSignatureWithDuration(duration: Duration, x: CGFloat, measure: Measure)
        -> TimeSignatureStratum {
        let timeSignature: TimeSignature = TimeSignature()
            .setMeasure(measure)
            .setTSStratum(self)
            .setNumerator(duration.beats.amount, denominator: duration.subdivision.value)
            .setSize(height)
            .setPosition(x, top: 0)
            .build()
        objects.append(timeSignature)
        return self
    }
    
    func addTimeSignatureSupplementalWithDuration(
        duration: Duration,
        x: CGFloat,
        measure: Measure
    ) -> TimeSignatureStratum {
        let timeSignature: TimeSignature = TimeSignatureSupplemental()
            .setMeasure(measure)
            .setTSStratum(self)
            .setNumerator(duration.beats.amount, denominator: duration.subdivision.value)
            .setSize(height)
            .setPosition(x, top: 0)
            .build()
        objects.append(timeSignature)
        return self
    }

    func build() -> TimeSignatureStratum {
        setFrame()
        for object in objects { addSublayer(object) }
        return self
    }
    
    override func setExternalPads() {
        externalPads.setBottom(0.1618 * height)
    }
}