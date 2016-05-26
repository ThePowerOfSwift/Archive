import UIKit

/**
MetronomeGrid
*/
class MetronomeGrid: CALayer {
    
    // MARK: Model Context
    
    var context: CALayer?
    
    /// Duration of Measure
    var gridDuration: Duration = Duration(0,16)
    
    // MARK: View Context
    
    /// All MetronomeGridLines in MetronomeGrid
    var metronomeGridLines: [MetronomeGridLine] = []
    
    /// All MetronomeGridRects in MetronomeGrid
    var metronomeGridRects: [MetronomeGridRect] = []
    
    var isIncluded: Bool = false
    
    // MARK: Size
    
    /// Graphical width of a single 8th-note
    var beatWidth: CGFloat = 0
    
    /// Width of a MetronomeGrid
    var width: CGFloat = 0
    
    /// Height of a MetronomeGrid
    var height: CGFloat = 0
    
    // MARK: Position
    
    /// Top of a MetronomeGrid
    var top: CGFloat = 0
    
    /// Left of a MetronomeGrid
    var left: CGFloat = 0
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a MetronomeGrid
    
    func setContext(context: CALayer) -> MetronomeGrid {
        self.context = context
        return self
    }
    
    func setBeatWidth(beatWidth: CGFloat) -> MetronomeGrid {
        self.beatWidth = beatWidth
        return self
    }
    
    func setGridDuration(duration: Duration) -> MetronomeGrid {
        self.gridDuration = duration
        return self
    }
    
    /**
    Set top of a Metronome
    
    :param: top Top of a MetronomeGrid
    
    :returns: Self: MetronomeGrid
    */
    func setTop(top: CGFloat) -> MetronomeGrid {
        self.top = top
        return self
    }
    
    /**
    Set left of a MetronomeGrid
    
    :param: left Left of a MetronomeGrid
    
    :returns: Self: MetronomeGrid
    */
    func setLeft(left: CGFloat) -> MetronomeGrid {
        self.left = left
        return self
    }
    
    /**
    Set left of a MetronomeGrid
    
    :param: left Left of a MetronomeGrid
    
    :returns: Self: MetronomeGrid
    */
    func setWidth(width: CGFloat) -> MetronomeGrid {
        self.width = width
        return self
    }
    
    /**
    Set left of a MetronomeGrid
    
    :param: left Left of a MetronomeGrid
    
    :returns: Self: MetronomeGrid
    */
    func setHeight(height: CGFloat) -> MetronomeGrid {
        self.height = height
        return self
    }
    
    func build() -> MetronomeGrid {
        setFrame()
        addMetronomeGridRects()
        return self
    }
    
    func addMetronomeGridRects() -> MetronomeGrid {
        let beats: Int = gridDuration.beats.amount
        for beat in 0..<beats {
            let x: CGFloat = width * (CGFloat(beat) / CGFloat(beats))
            let rectWidth: CGFloat = width * (1.0 / CGFloat(beats))
            addMetronomeGridRect(x: x, width: rectWidth)
        }
        for rect in metronomeGridRects { addSublayer(rect) }
        return self
    }
    
    func addMetronomeGridRect(#x: CGFloat, width: CGFloat) -> MetronomeGrid {
        let rect: MetronomeGridRect = MetronomeGridRect()
            .setLeft(x)
            .setTop(top)
            .setHeight(frame.height)
            .setWidth(width)
            .build()
        metronomeGridRects.append(rect)
        return self
    }
    
    func addMetronomeGridLines() -> MetronomeGrid {
        let beats: Int = gridDuration.beats.amount
        for beat in 1..<beats {
            let x: CGFloat = width * (CGFloat(beat) / CGFloat(beats))
            addMetronomeGridLineAtX(x)
        }
        for metronomeGridLine in metronomeGridLines { addSublayer(metronomeGridLine) }
        return self
    }
    
    func addMetronomeGridLineAtX(x: CGFloat) -> MetronomeGrid {
        let line: MetronomeGridLine = MetronomeGridLine()
            .setX(x)
            .setTop(0)
            .setBottom(frame.height)
            .build()
        metronomeGridLines.append(line)
        return self
    }
    
    // MARK: User Interface
    
    func switchIncludedState() {
        if isIncluded { exclude() }
        else { include() }
    }
    
    func include() {
        if !isIncluded {
            CATransaction.setDisableActions(true)
            context!.insertSublayer(self, atIndex: 0)
            CATransaction.setDisableActions(false)
        }
        isIncluded = true
    }
    
    func exclude() {
        if isIncluded {
            CATransaction.setDisableActions(true)
            removeFromSuperlayer()
            CATransaction.setDisableActions(false)
        }
        isIncluded = false
    }
    
    func resize() -> MetronomeGrid {
        setFrame()
        if superlayer == nil { CATransaction.setDisableActions(true) }
        //for line in metronomeGridLines { line.setBottom(height).resize() }
        for rect in metronomeGridRects { rect.setHeight(height).setFrame() }
        CATransaction.setDisableActions(false)
        return self
    }
    
    func setFrame() {
        frame = CGRectMake(left, top, width, height)
    }
}