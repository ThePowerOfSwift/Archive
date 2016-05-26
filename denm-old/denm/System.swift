import UIKit
import QuartzCore

/**
System
*/
class System: StratumContainer {
    
    // MARK: View Context
    
    /// Page containing of System
    var page: Page?
    
    // MARK: Attributes
    
    /// Total cumulative Duration of System
    var totalDuration: Duration = Duration(0,16)
    
    /// Duration that System is offset from beginning of piece: this will become more sophisticated
    var offsetDuration: Duration = Duration(0,16)
    
    /// number (0-based) of first measure
    var measureStart: Int = 0
    
    /// number (0-based) of last measure
    var measureEnd: Int = 0
    
    /// x-value of starting point of musical information in System
    var infoStartX: CGFloat = 0
    
    // MARK: Size
    
    /// Maximum allowable width of System
    var maxWidth: CGFloat = 0
    
    /// Graphical width of a single 8th-note
    var beatWidth: CGFloat = 0

    // MARK: Components
    
    /// Measures in System
    var measures: [Measure] = []
    
    var spanTrees: [SpanTree] = []
    
    /// Performers in System
    var performers: [Performer] = []
    
    /// BGStrata (Beam Group Strata) in System
    var bgStrata: [BGStratum] = []
    
    // for testing only! KILL!
    var graphs: [Graph] = []
    var beamGroups: [BeamGroup] = []
    
    var testStaff: Staff = Staff()
    var testPerformer: Performer = Performer()
    var testBGStratum: BGStratum = BGStratum()
    
    override init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a System
    
    /**
    Set Page containing System
    
    :param: page Page containing System
    
    :returns: Self: System
    */
    func setPage(page: Page) -> System {
        self.page = page
        return self
    }
    
    /**
    Set position of System
    
    :param: left left of System
    :param: top  top of System
    
    :returns: Self: System
    */
    func setPosition(left: CGFloat, top: CGFloat) -> System {
        self.left = left
        self.top = top
        return self
    }

    /**
    Set top of System
    
    :param: top top of System
    
    :returns: Self: System
    */
    func setTop(top: CGFloat) -> System {
        self.top = top
        return self
    }
    
    /**
    Set left of System
    
    :param: left left of System
    
    :returns: Self: System
    */
    func setLeft(left: CGFloat) -> System {
        self.left = left
        return self
    }
    
    /**
    Set x-value of starting point of musical information in System
    
    :param: infoStartX starting point of musical information in System
    
    :returns: Self: System
    */
    func setInfoStartX(infoStartX: CGFloat) -> System {
        self.infoStartX = infoStartX
        return self
    }
    
    func setOffsetDuration(offsetDuration: Duration) -> System {
        self.offsetDuration = offsetDuration
        return self
    }
    
    /**
    Set height of System
    
    :param: height height of System
    
    :returns: Self: System
    */
    func setHeight(height: CGFloat) -> System {
        self.height = height
        return self
    }
    
    /**
    Set graphical width of a single 8th-note in System
    
    :param: beatWidth Graphical width of a single 8th-note
    
    :returns: Self: System
    */
    func setBeatWidth(beatWidth: CGFloat) -> System {
        self.beatWidth = beatWidth
        return self
    }
    
    /**
    Set maximum allowable width of System
    
    :param: maxWidth maximum allowable width of System
    
    :returns: Self: System
    */
    func setMaxWidth(maxWidth: CGFloat) -> System {
        self.maxWidth = maxWidth
        return self
    }
    
    /**
    Set width of System
    
    :param: width width of System
    
    :returns: Self: System
    */
    func setWidth(width: CGFloat) -> System {
        self.width = width
        return self
    }
    
    /**
    Set measures of System
    
    :param: measures Measures of System
    
    :returns: Self: System
    */
    func setMeasures(measures: [Measure]) -> System {
        self.measures = measures
        setSystemOfAllMeasuresToSelf()
        setOffsetDuration(measures[0].offsetDuration)
        setTotalDurationWithMeasures()
        
        // somewhere else!
        addMeasureStrata()
        return self
    }
    
    private func setSystemOfAllMeasuresToSelf() {
        for measure in measures { measure.setSystem(self) }
    }
    
    func setSpanTrees(spanTrees: [SpanTree]) -> System {
        self.spanTrees = spanTrees
        return self
    }
    
    /**
    Add all necessary components to System layer
    
    :returns: Self: System
    */
    override func build() -> System {
        addBeamGroupsFromAllSpanTrees()
        positionStrata()
        addBarlines()
        addMetronomeGrids()
        commitStrata()
        addStems()
        setFrame()
        return self
    }
    
    func insertTestBeamGroupAndStaff(#x: CGFloat) -> System {
        let g_cue: CGFloat = 6
        testPerformer = Performer(id: "VN")
        let testInstrument = Instrument(id: "VN")
        testStaff = Staff()
            .setSize(g: g_cue)
            .addClef("treble", x: x - 20)
        testInstrument.addGraph(testStaff)
        testPerformer.addInstrument(testInstrument)
        testPerformer.build()
        
        testBGStratum = BGStratum()
            .setSystem(self)
            .setSize(g: g_cue, beatWidth: beatWidth)
            .setLeft(x)
            .setOrientation(1)
        
        let spanTree1: SpanTree = SpanTree(beats: 2, subdivision: 16, sequence: [1,1,2,1])
            .addRandomPitchInfoToLeavesWithPerformerID("VN")
        let spanTree2: SpanTree = SpanTree(beats: 3, subdivision: 16, sequence: [1,2,2,2])
            .addRandomPitchInfoToLeavesWithPerformerID("VN")
        let testBeamGroup1 = BeamGroup().setSpanTree(spanTree1)
        let testBeamGroup2 = BeamGroup().setSpanTree(spanTree2)
        testBGStratum.addBeamGroup(testBeamGroup1)
        testBGStratum.addBeamGroup(testBeamGroup2)
        testBeamGroup1.build()
        testBeamGroup2.build()
        testBGStratum.build()
        
        
        for beamGroup in testBGStratum.beamGroups {
            for bgLeaf in beamGroup.leaves {
                let x: CGFloat = testBGStratum.left + beamGroup.left + bgLeaf.xInBeamGroup
                for component in bgLeaf.spanLeaf!.components {
                    switch component {
                    case .Pitch(let pID, let iID, let pitches):
                        testStaff.startNewEventAt(x)
                        testStaff.addPitchesToCurrentEvent(pitches: pitches)
                        bgLeaf.addGraphEvent(testStaff.getCurrentEvent())
                    default: break
                    }
                }
            }
        }
        
        testStaff.stopLinesAt(x: frame.width).build()
        
        for beamGroup in testBGStratum.beamGroups {
            for bgLeaf in beamGroup.leaves {
                bgLeaf.addStem()
            }
        }
        
        testStaff.addLabel("VN")
        
        // get tsStratum
        var tsStratum: TimeSignatureStratum?
        for stratum in strata {
            if let timeSignatureStratum = stratum as? TimeSignatureStratum {
                tsStratum = timeSignatureStratum
                break
            }
        }
        // insert testStaff after tsStratum
        testStaff.beginTime = CACurrentMediaTime() + 0.05
        testBGStratum.beginTime = CACurrentMediaTime() + 0.05
        insertStratum(testBGStratum, afterStratum: tsStratum!)
        insertStratum(testStaff, afterStratum: testBGStratum)
        
        // is it the best way to separate insertStratum and addSublayer()?
        
        CATransaction.setDisableActions(true)
        addSublayer(testBGStratum)
        addSublayer(testStaff)
        CATransaction.setDisableActions(false)
        return self
    }
    
    func switchIncludedStateOfTestBeamGroupAndStaff(#x: CGFloat) -> System {
        var containsTestGraph: Bool = false
        for layer in sublayers {
            if layer === testStaff {
                containsTestGraph = true
                break
            }
        }
        if containsTestGraph {
            CATransaction.setDisableActions(true)
            testBGStratum.removeFromSuperlayer()
            testStaff.removeFromSuperlayer()
            
            removeStratum(testBGStratum)
            removeStratum(testStaff)
            CATransaction.setDisableActions(false)
        }
        else { insertTestBeamGroupAndStaff(x: x) }
        return self
    }
    
    /**
    Overrides StratumContainer.positionStrata()
    */
    override func positionStrata() {
        var accumTop: CGFloat = 0
        for stratum in strata {
            setStratumLeft(stratum)
            accumulateTopPad(&accumTop, stratum: stratum)
            repositionStratum(accumTop, stratum: stratum)
            accumulateHeight(&accumTop, stratum: stratum)
            accumulateBottomPad(&accumTop, stratum: stratum)
        }
        height = accumTop
        setFrame()
        resizeComponents()
        if container != nil { container!.positionStrata() }
    }
    
    func resizeComponents() -> System {
        resizeBarlines()
        resizeMetronomeGrids()
        return self
    }
    
    /**
    Animates barline lengths when height of System is adjusted: change to "resize"
    */
    func resizeBarlines() {
        for measure in measures {
            for barline in measure.barlines { barline.setBottom(height).resize() }
        }
    }
    
    func resizeMetronomeGrids() -> System {
        for measure in measures {
            measure.metronomeGrid?.setHeight(height - getBarlineTop()).resize()
        }
        return self
    }
    
    /**
    Add MetronomeGrids to System
    */
    func addMetronomeGrids() {
        let barlineTop: CGFloat = getBarlineTop()
        for measure in measures {
            measure.createMetronomeGrid()
            measure.addMetronomeGridToSystem(self, top: barlineTop)
        }
    }
    
    /**
    Add barlines to System
    */
    func addBarlines() {
        for measure in measures {
            let barlineTop: CGFloat = getBarlineTop()
            measure.setHeight(frame.height)
            measure.addBarlineLeftToSystem(self, top: barlineTop)
            if measure === measures.last! {
                measure.addBarlineRightToSystem(self, top: barlineTop)
            }
        }
    }
    
    func addStems() {
        for bgStratum in bgStrata {
            for bg in bgStratum.beamGroups { for bgLeaf in bg.leaves { bgLeaf.addStem() } }
        }
    }
    
    /*
    func setMeasureRange(measureStart: Int, allMeasures: [Measure]) -> System {
        self.measureStart = measureStart
        var accumWidth: CGFloat = infoStartX
        var m: Int = measureStart
        while accumWidth < maxWidth && m < allMeasures.count {
            let measure: Measure = allMeasures[m]
                .setSystem(self)
                .setLeft(accumWidth)
                .setBeatWidth(beatWidth)
                .setNumber(m + 1)
                .build()
            if accumWidth + measure.width <= maxWidth {
                addMeasure(measure)
                accumWidth += measure.width
                m++
            } else { break }
        }
        measureEnd = m
        width = accumWidth
        setTotalDurationWithMeasures()
        
        // this assumes that TimeSignature / MeasureNumber are bound to top of System
        addMeasureStrata()
        return self
    }
    */
    
    /**
    Add Measure to System
    
    :param: measure Measure
    
    :returns: Self: System
    */
    func addMeasure(measure: Measure) -> System {
        measures.append(measure)
        return self
    }
    
    /**
    Add Performer to System
    
    :param: performer Performer
    
    :returns: Self: System
    */
    func addPerformer(performer: Performer) -> System {
        performers.append(performer)
        return self
    }
    
    /**
    Add Graph to System
    
    :param: graph Graph
    
    :returns: Self: System
    */
    func addGraph(graph: Graph) -> System {
        graphs.append(graph)
        return self
    }
    
    /**
    Add BeamGroup to System
    
    :param: beamGroup BeamGroup
    
    :returns: Self: System
    */
    func addBeamGroup(beamGroup: BeamGroup) -> System {
        beamGroups.append(beamGroup)
        return self
    }
    
    // MARK: User Interface
    
    func play() {
        page!.play()
    }
    
    func highlightBGStrata() {
        for bgStratum in bgStrata { bgStratum.play() }
    }
    
    internal func addMeasureStrata() {
        let measureNumberStratum = MeasureNumberStratum().setSystem(self).setSize(15)
        let timeSignatureStratum = TimeSignatureStratum().setSystem(self).setSize(40)
        var accumLeft: CGFloat = infoStartX
        var measureCount: Int = 1
        for measure in measures {
            measure.addMeasureNumber(measureNumberStratum)
            measure.addTimeSignature(timeSignatureStratum)
            accumLeft += measure.width
            measureCount++
        }
        width = accumLeft
        measureNumberStratum.build()
        timeSignatureStratum.build()
        addStratum(measureNumberStratum)
        addStratum(timeSignatureStratum)
    }
    
    private func getBarlineTop() -> CGFloat {
        var height: CGFloat = 0
        for stratum in strata {
            if let timeSignatureStratum = stratum as? TimeSignatureStratum {
                height = (
                    timeSignatureStratum.frame.maxY +
                    timeSignatureStratum.externalPads.getBottom()
                )
            }
        }
        return height
    }
    
    func setSpanTreeRange(allSpanTrees: [SpanTree]) -> System {
        
        // this will rely on Duration overloading of += -= <= >= == != correctly
        
        let systemBegin: Duration = offsetDuration
        let systemEnd: Duration = offsetDuration + totalDuration
        for spanTree in allSpanTrees {
            let spanTreeBegin: Duration = spanTree.offsetDuration
            let spanTreeEnd: Duration = spanTree.offsetDuration + spanTree.root.duration
            if spanTreeBegin.beats.amount >= systemBegin.beats.amount {
                if spanTreeEnd.beats.amount <= systemEnd.beats.amount {
                    spanTrees.append(spanTree)
                }
            }
        }
        return self
    }

    func addBeamGroupsFromAllSpanTrees() -> System {
        let performerFL: Performer = Performer(id: "FL")
        let instrumentFL: Instrument = Instrument(id: "FL")
        let graphSoundingFL: Staff = Staff()
            .setSize(g: 8)
            .addClef("treble", x: 0)
        instrumentFL.addGraph(graphSoundingFL)
        performerFL.addInstrument(instrumentFL)
        addPerformer(performerFL)
        
        let bgStratum: BGStratum = BGStratum()
            .setSystem(self)
            .setSize(g: 8, beatWidth: beatWidth)
            .setLeft(infoStartX)
            .setOrientation(1)
        
        for spanTree in spanTrees {
            let offsetDur: Duration = spanTree.offsetDuration
            let left: CGFloat = offsetDur.getGraphicalWidth(beatWidth)
            let beamGroup: BeamGroup = BeamGroup(spanTree: spanTree)
            bgStratum.addBeamGroup(beamGroup)
        }
        bgStrata.append(bgStratum)

        // encapsulate
        for bgStratum in bgStrata {
            for beamGroup in bgStratum.beamGroups { beamGroup.build() }
        }
        
        bgStratum.build()
        addStratum(bgStratum)
        
        let spanComponentManager: SpanComponentManager = SpanComponentManager()
            .setBGStrata(bgStrata)
            .setPerformers(performers)
            .populateGraphs()
        
        let dmStratum: DMStratum = DMStratum()!.setHeight(20)
        
        // to become SpanComponentManager
        for bg in bgStrata[0].beamGroups {
            for leaf in bg.leaves {
                let x = leaf.xInBeamGroup + bg.left + bg.bgStratum!.left
                
                for component in leaf.spanLeaf!.components {
                    switch component {
                    case .Dynamic(let pID, let iID, let marking):
                        if dmStratum.dynamicMarkings.count > 0 {
                            dmStratum.addInterpolationHairpin()
                        }
                        let dynamicMarking = DynamicMarking(string: marking)
                        dmStratum.addDynamicMarking(dynamicMarking, x: x)
                        break
                    default: break
                    }
                    
                    /*
                    if let dynamicComponent = component as? SpanComponentDynamic {
                        let dynamic: String = dynamicComponent.dynamicMarking
                        if dmStratum.dynamicMarkings.count > 0 {
                            dmStratum.addInterpolationHairpin()
                        }
                        dmStratum.addDynamicMarking(DynamicMarking(string: dynamic), x: x)
                    }
                    */
                }
            }
        }
        
        
        graphSoundingFL.stopLinesAt(x: measures.last!.frame.maxX)
        graphSoundingFL.build()
        graphSoundingFL.setContainer(self)
        
        addStratum(graphSoundingFL)
        
        dmStratum.build()
        addStratum(dmStratum)
        
        return self
    }
    // <---------------------------------------------------------------------------------- KILL

    
    internal func setTotalDurationWithMeasures() {
        for measure in measures { totalDuration += measure.duration }
    }
    
    func highlight() {
        backgroundColor = UIColor.lightGrayColor().CGColor
    }
    
    override func setFrame() {
        setExternalPads()
        frame = CGRectMake(left, top, width, height)
    }
    
    override func setExternalPads() {
        externalPads.setBottom(15)
        externalPads.setLeft(20)
    }
}