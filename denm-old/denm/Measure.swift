import QuartzCore
import UIKit

/**
Graphical collection of objects pertaining to a Measure-organization of metrical time

The measure does not contain any actual musical information from the Model, but is instead "zipped" onto BeamGroups (Graphical representations of SpanTree)
*/
class Measure: Printable {
    
    var description: String { get { return "Measure: \(duration)" } }
    
    // MARK: View Context
    
    var system: System?
    
    // MARK: Attributes
    
    /// Duration into the work that Measure begins
    var offsetDuration: Duration = Duration()
    
    /// Duration of Measure
    var duration: Duration = Duration()
    
    /// Measure number (0-based; graphically-represented as 1-based)
    var number: Int = 0
    
    // MARK: Size
    
    /// Height of Measure
    var height: CGFloat = 0
    
    /// Width of Measure
    var width: CGFloat = 0
    
    /// Graphical width of a single 8th-note
    var beatWidth: CGFloat = 0
    
    /// Frame of Measure (Measure is not an actually layer in the CALayer context)
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    
    // MARK: Position
    
    /// Left of Measure
    var left: CGFloat = 0
    
    /// Top of Measure
    var top: CGFloat = 0 // ever not 0?

    // MARK: Components
    
    /// Collection of Barlines contained in Measure
    var barlines: [Barline] = []
    
    /// Left Barline of Measure
    var barlineLeft: Barline?
    
    /// Right Barline of Measure
    var barlineRight: Barline?
    
    var metronomeGrid: MetronomeGrid?
    
    // for testing only
    var spanTree: SpanTree?
    
    init() {}
    
    init(duration: Duration) {
        self.duration = duration
    }
    
    init(offsetDuration: Duration) {
        self.offsetDuration = offsetDuration
    }
    
    func setSpanTree(spanTree: SpanTree) -> Measure {
        self.spanTree = spanTree
        return self
    }
    
    // MARK: Incrementally build a Measure
    
    func setSystem(system: System) -> Measure {
        self.system = system
        return self
    }
    
    /**
    Set Offset Duration of Measure
    
    :param: duration Duration into the work that Measure begins
    
    :returns: Self: Measure
    */
    func setOffsetDuration(duration: Duration) -> Measure {
        self.offsetDuration = duration
        return self
    }
    
    /**
    Set Duration of Measure
    
    :param: duration Duration of Measure
    
    :returns: Self: Measure
    */
    func setDuration(duration: Duration) -> Measure {
        self.duration = duration
        return self
    }
    
    /**
    Set Number of Measure (0-based; graphically-represented as 1-based)
    
    :param: number Number of Measure
    
    :returns: Self: Measure
    */
    func setNumber(number: Int) -> Measure {
        self.number = number
        return self
    }
    
    /**
    Set Height of Measure
    
    :param: height Height of Measure
    
    :returns: Self: Measure
    */
    func setHeight(height: CGFloat) -> Measure {
        self.height = height
        return self
    }
    
    func setWidth(width: CGFloat) -> Measure {
        self.width = width
        return self
    }
    
    /**
    Set Left of Measure
    
    :param: left Left of Measure
    
    :returns: Self: Measure
    */
    func setLeft(left: CGFloat) -> Measure {
        self.left = left
        return self
    }
    
    /**
    Set BeatWidth of Measure
    
    :param: beatWidth Graphical width of a single 8th-note
    
    :returns: Self: Measure
    */
    func setBeatWidth(beatWidth: CGFloat) -> Measure {
        self.beatWidth = beatWidth
        return self
    }
    
    /**
    Add MeasureNumber to MeasureNumberStratum
    
    :param: measureNumberStratum MeasureNumberStratum
    */
    func addMeasureNumber(measureNumberStratum: MeasureNumberStratum) {
        measureNumberStratum.addMeasureNumberWithNumber(number, x: left, measure: self)
    }
    
    /**
    Add TimeSignature to TimeSignatureStratum
    
    :param: timeSignatureStratum TimeSignatureStratum
    */
    func addTimeSignature(timeSignatureStratum: TimeSignatureStratum) {
        timeSignatureStratum.addTimeSignatureWithDuration(duration, x: left, measure: self)
    }
    
    /**
    Add TimeSignatureSupplemental to TimeSignatureStratum
    
    :param: timeSignatureStratum TimeSignatureStratum
    */
    func addTimeSignatureSupplemental(timeSignatureStratum: TimeSignatureStratum) {
        timeSignatureStratum.addTimeSignatureWithDuration(duration, x: left + width, measure: self)
    }
    
    /**
    Add BarlineLeft of Measure to System containing Measure
    
    :param: system System containing Measure
    :param: top    Top of Barline in System context
    
    :returns: Self: Measure
    */
    func addBarlineLeftToSystem(system: System, top: CGFloat) -> Measure {
        setFrame()
        let barline: Barline = Barline()
            .setX(left)
            .setTop(top)
            .setBottom(height)
            .build()
        system.addSublayer(barline)
        barlines.append(barline)
        return self
    }
    
    /**
    Add BarlineRight of Measure of System containing Measure
    
    :param: system System containing Measure
    :param: top    Top of Barline in System context
    
    :returns: Self: Measure
    */
    func addBarlineRightToSystem(system: System, top: CGFloat) -> Measure {
        setFrame()
        let barline: Barline = Barline()
            .setX(left + width)
            .setTop(top)
            .setBottom(height)
            .build()
        system.addSublayer(barline)
        barlines.append(barline)
        return self
    }
    
    func createMetronomeGrid() -> Measure {
        metronomeGrid = MetronomeGrid()
            .setContext(system!)
            .setGridDuration(duration)
            .setLeft(left)
            .setTop(top)
            .setWidth(width)
            .setHeight(height)
            .build()
        return self
    }
    
    func tap() -> Measure {
        metronomeGrid!.switchIncludedState()
        return self
    }
    
    func addMetronomeGridToSystem(system: System, top: CGFloat) -> Measure {
        metronomeGrid!.setTop(top).setHeight(system.height - top).setFrame()
        var tsStratum: TimeSignatureStratum?
        for stratum in system.strata {
            if let timeSignatureStratum = stratum as? TimeSignatureStratum {
                tsStratum = timeSignatureStratum
                break
            }
        }
        //system.insertSublayer(metronomeGrid, below: tsStratum!)
        return self
    }
    
    /**
    Build Measure
    
    :returns: Self: Measure
    */
    func build() -> Measure {
        setFrame()
        return self
    }
    
    internal func setFrame() {
        //setWidthWithBeatWidth()
        frame = CGRectMake(left, top, width, height)
    }
    
    
    internal func setWidthWithBeatWidth() {
        width = duration.getGraphicalWidth(beatWidth)
    }
}