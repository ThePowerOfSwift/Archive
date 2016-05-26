import UIKit
import QuartzCore

/**
Container of all Systems (and any other components necessary) on a single view
*/
class Page: StratumContainer, Printable {
    
    /// Printable description of this Page
    override var description: String { get { return "Page with \(systems.count) systems" } }
    
    // MARK: Attributes
    
    var totalDuration: Duration = Duration(0,16)
    
    /// Duration that Page is offset from beginning of piece: this will become more sophisticated
    var offsetDuration: Duration = Duration(0,16)
    
    // MARK: Model Context
    
    /// All measures in piece ---- this will become the basic MODEL object! but now gross
    var allMeasures: [Measure] = []
    
    /// All spantrees in piece ---- this is for testing only!
    var allSpanTrees: [SpanTree] = []
    
    // MARK: View Context
    
    /// All systems contained on Page
    var systems: [System] = []
    
    var systemStart: Int = 0
    
    var measureStart: Int = 0
    
    var measureEnd: Int = 0
    
    // MARK: Size
    
    var maxHeight: CGFloat = 0
    
    /// Graphical width of a single 8th-note
    var beatWidth: CGFloat = 0
    
    var systemCount: Int = 0
    
    // MARK: Incrementally build a Page
    
    /**
    Set all Systems contained in Page
    
    :param: systems Systems
    
    :returns: Self: Page
    */
    func setSystems(systems: [System]) -> Page {
        self.systems = systems
        setPageOfAllSystemsToSelf()
        return self
    }
    
    /**
    Set beatWidth of Page
    
    :param: beatWidth Graphical width of a single 8th-note
    
    :returns: Self: Page
    */
    func setBeatWidth(beatWidth: CGFloat) -> Page {
        self.beatWidth = beatWidth
        return self
    }
    
    /**
    Set top of Page
    
    :param: top Top of Page
    
    :returns: Self: Page
    */
    func setTop(top: CGFloat) -> Page {
        self.top = top
        return self
    }
    
    func setMaxHeight(maxHeight: CGFloat) -> Page {
        self.maxHeight = maxHeight
        return self
    }
    
    /**
    Set model of music that comprises the entire piece. This is temporary; will be more better
    
    :param: allMeasures All the music in the piece (temp)
    
    :returns: Self: Page
    */
    func setAllMeasures(allMeasures: [Measure]) -> Page {
        self.allMeasures = allMeasures
        return self
    }
    
    // temp
    func setAllSpanTrees(allSpanTrees: [SpanTree]) -> Page {
        self.allSpanTrees = allSpanTrees
        return self
    }
    
    func setMeasureStart(measureStart: Int) -> Page {
        self.measureStart = measureStart
        return self
    }
    
    func setMeasureEnd(measureEnd: Int) -> Page {
        self.measureEnd = measureEnd
        return self
    }
    
    /**
    Add System to Page
    
    :param: system System
    
    :returns: Self: Page
    */
    func addSystem(system: System) -> Page {
        systems.append(system)
        //addStratum(system)
        return self
    }
    
    /**
    Build Page
    
    :returns: Self: Page
    */
    override func build() -> Page {
        for system in systems { addStratum(system) }
        commitStrata()
        positionStrata()
        
        width = 968
        setFrame()
        return self
    }
    
    // MARK: User Interface
    
    func play() {
        for system in systems {
            let offset: Double = system.offsetDuration.getTemporalLength(1)
            var timer: NSTimer = NSTimer()
            timer = NSTimer.scheduledTimerWithTimeInterval(offset,
                target: self,
                selector: Selector("playNextSystem"),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    func playNextSystem() {
        if systemCount >= systems.count { systemCount = 0 }
        systems[systemCount].highlightBGStrata()
        systemCount++
    }
    
    func addNextSystem() {
        let nextSystem: System = systems[strata.count]
        addStratum(nextSystem)
        CATransaction.setDisableActions(true)
        addSublayer(nextSystem)
        CATransaction.setDisableActions(false)
        positionStrata()
    }
    
    func removeLastSystem() {
        CATransaction.setDisableActions(true)
        strata.last!.removeFromSuperlayer()
        CATransaction.setDisableActions(false)
        strata.last!.removeFromContainer()
        positionStrata()
    }
    
    func goToNextSystem() {
        println("page.goToNextSystem()")
    }
    
    func goToPreviousSystem() {
        println("page.goToPreviousSystem()")
    }
    
    private func setPageOfAllSystemsToSelf() {
        for system in systems { system.setPage(self) }
    }
    
    override func setExternalPads() {
        //externalPads.setLeft(25)
        //externalPads.setTop(15)
    }
}