import UIKit

/**
Performer-facing View containing Pages of musical material. All UI happens in here.
*/
class PerformerView: StratumContainer {
    
    /// All Pages contained in PerformerView
    var pages: [Page] = []
    
    /// All Measures contained in PerformerView
    var allMeasures: [Measure] = [] // temporary: this should be externalized ?
    
    /// All SpanTrees contained in PerformerView
    var allSpanTrees: [SpanTree] = []

    /// Graphical width of a single 8th-note; this will be flexible, externalized
    var beatWidth: CGFloat = 0
    
    /// Maximum duration allowed in PerformerView, based on screen resolution, orientation, etc
    let maximumDuration: Duration = Duration(15,16) // convert frame.width into Duration :/
    
    // MARK: Incrementally build a PerformerView
    
    /**
    Set all Measures of a PerformerView
    
    :param: measures Measures
    
    :returns: Self: PerformerView
    */
    func setAllMeasures(measures: [Measure]) -> PerformerView {
        self.allMeasures = measures
        return self
    }
    
    /**
    Set all SpanTrees of a PerformerView
    
    :param: spanTrees Measures
    
    :returns: Self: PerformerView
    */
    func setAllSpanTrees(spanTrees: [SpanTree]) -> PerformerView {
        self.allSpanTrees = spanTrees
        return self
    }
    
    /**
    Set beatWidth of a PerformerView
    
    :param: beatWidth Graphical width of a single 8th-note
    
    :returns: Self: PerformerView
    */
    func setBeatWidth(beatWidth: CGFloat) -> PerformerView {
        self.beatWidth = beatWidth
        return self
    }
    
    /**
    Set Width of a PerformerView
    
    :param: width Width of a PerformerView
    
    :returns: Self: PerformerView
    */
    func setWidth(width: CGFloat) -> PerformerView {
        self.width = width
        return self
    }
    
    /**
    Set Height of a PerformerView
    
    :param: height Height of a PerformerView
    
    :returns: Self: PerformerView
    */
    func setHeight(height: CGFloat) -> PerformerView {
        self.height = height
        return self
    }
    
    /**
    Set Top of a PerformerView
    
    :param: top Top of a PerformerView
    
    :returns: Self: PerformerView
    */
    func setTop(top: CGFloat) -> PerformerView {
        self.top = top
        return self
    }
    
    // MARK: User Interface
    
    var currentPage: Page = Page()
    
    /**
    Add all necessary components to PerformerView
    
    :returns: Self: Complete PerformerView
    */
    override func build() -> PerformerView {
        createPages()
        positionStrata()
        commitStrata()
        return self
    }
    
    private func createPages() {
        let allSystems: [System] = makeAllSystems()
        let maximumHeight: CGFloat = 768 // refine, detect display
        var firstSystemIndex: Int = 0
        while firstSystemIndex < allSystems.count {
            let systems: [System] = GetSystemRange()
                .setFirstSystemIndex(firstSystemIndex)
                .setMaximumHeight(maximumHeight)
                .getRangeFromSystems(allSystems)
            addPageWithSystems(systems)
            firstSystemIndex += systems.count
        }
        // this will be deferred and dealt with in the UI realm (footpedal, etc)
        commitPages()
    }
    
    private func addPageWithSystems(systems: [System]) {
        let page: Page = Page()
            .setSystems(systems)
            .setTop(20)
            .build()
        pages.append(page)
    }
    
    private func commitPages() {
        for page in pages { addStratum(page) }
    }
    
    private func makeAllSystems() -> [System] {
        prebuildMeasures()
        var systems: [System] = []
        var firstMeasureIndex: Int = 0
        while firstMeasureIndex < allMeasures.count {
            let measures: [Measure] = makeMeasuresAtIndex(firstMeasureIndex)
            let spanTrees: [SpanTree] = makeSpanTreesInMeasureRange(measures: measures)
            let system: System = makeSystemWithMeasures(measures, spanTrees: spanTrees)
            systems.append(system)
            firstMeasureIndex += measures.count
        }
        return systems
    }
    
    private func makeSystemWithMeasures(measures: [Measure], spanTrees: [SpanTree]) -> System {
        let system: System = System()
            .setInfoStartX(30) // refine internally within system
            .setBeatWidth(beatWidth) // refine
            .setMeasures(measures)
            .setSpanTrees(spanTrees)
            .build()
        return system
    }
    
    private func makeSpanTreesInMeasureRange(#measures: [Measure]) -> [SpanTree] {
        let maximumDuration: Duration = getSystemDurationWithMeasures(measures)
        let spanTrees: [SpanTree] = GetSpanTreeRange()
            .setOffsetDuration(measures[0].offsetDuration)
            .setMaximumDuration(maximumDuration)
            .getRangeFromSpanTrees(allSpanTrees)
        return spanTrees
    }
    
    private func makeMeasuresAtIndex(index: Int) -> [Measure] {
        let infoStartX: CGFloat = 30
        let measures: [Measure] = GetMeasureRange()
            .setInfoStartX(infoStartX)
            .setFirstMeasureIndex(index)
            .setMaximumDuration(maximumDuration)
            .getRangeFromMeasures(allMeasures)
        return measures
    }
    
    private func getSystemDurationWithMeasures(measures: [Measure]) -> Duration {
        var accumDur: Duration = Duration(0,16)
        for measure in measures { accumDur += measure.duration }
        return accumDur
    }
    
    private func prebuildMeasures() {
        for (measureNumber, measure) in enumerate(allMeasures) {
            measure.setNumber(measureNumber + 1)
            measure.setWidth(measure.duration.getGraphicalWidth(beatWidth))
        }
    }
    
    func goToNextPage() {
        
        // exit current page (with diff animations: slide, ?, etc)
        // go to next
    }
    
    func goToPreviousPage() {
        // exit current page (see above)
        // go to prev
    }
}