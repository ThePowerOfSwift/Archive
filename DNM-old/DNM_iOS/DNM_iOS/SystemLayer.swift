//
//  SystemLayer.swift
//  DNM_iOS
//
//  Created by James Bean on 8/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

// IN-PROCESS: Refactoring responsibilities out of here (2015-12-29)
/// A Musical SystemLayer (container of a single line's worth of music)
public class SystemLayer: ViewNode, BuildPattern {
    
    /// String representation of SystemLayer
    public override var description: String { get { return getDescription() }  }
    
    /// ViewModel of SystemLayer
    public var viewModel: SystemViewModel!
    
    /// PageLayer containing this SystemLayer
    public var page: PageLayer?
    
    // MARK: - ViewNode Structure
    
    /** TemporalInfoNode of this SystemLayer. Contains:
    - TimeSignatureNode
    - MeasureNumberNode
    - TempoMarkingsNode
    */
    public var temporalInfoNode = TemporalInfoNode(height: 75)
    
    /**
    EventsNode of SystemLayer. Stacked after the `temporalInfoNode`.
    Contains all non-temporal musical information (`Performers`, `BGStrata`, `DMNodes`, etc).
    */
    public var eventsNode = ViewNode(stackVerticallyFrom: .Top)

    // MARK: - Measures
    
    /// All MeasureViews contained in this SystemLayer
    public var measureViews: [MeasureView] = []
    
    /// Layer for Barlines. First (most background) layer of EventsNode
    private let barlinesLayer = CALayer()
    
    /// All Barlines in this SystemLayer
    private var barlines: [Barline] = []

    // MARK: - Musical Information
    
    /**
    All BGStrata organized by identifier.
    This implementation assumes that there is only one PerformerID per BeamGroupStrata 
    (and therefore BeamGroupStratum, and therefore BeamGroupEvent, etc.).
    */
    public var beamGroupStrataByPerformerID: [String : [BeamGroupStratum]] = [:]
    
    /// Performers organized by identifier `String` -- MAKE ORDERED DICTIONARY
    public var performerStratumByID: [PerformerID: PerformerStratum] = [:]
    
    // TODO: doc comment
    public var instrumentEvents: [InstrumentEvent] = []
    
    /// All GraphEvents contained within this SystemLayer
    public var graphEvents: [GraphEvent] { return getGraphEvents() }
    
    /// DynamicMarkingNodes organized by identifier
    public var dynamicMarkingNodeByPerformerID: [PerformerID : DynamicMarkingStratum] = [:]
    
    public var labelStratumByPerformerID: [PerformerID: LabelStratum] = [:]

    // MARK: - Dimensional Attributes
    
    /// Horiztonal starting point of musical information
    public var infoStartX: CGFloat = 50
    
    /**
    Minimum vertical value for PerformerStratum, for the purposes of Barline placement.
    This is the highest graphTop contained within the
    PerformerStratum -> InstrumentStratum -> GraphLayer hierarchy.
    */
    public var minPerformersTop: CGFloat? { get { return getMinPerformersTop() } }
    
    /**
    Maximum vertical value for PerformerStratum, for the purposes of Barline placement.
    This is the lowest graphBottom contained within the
    PerformerStratum -> InstrumentStratum -> GraphLayer hierarchy.
    */
    public var maxPerformersBottom: CGFloat? { get { return getMaxPerformersBottom() } }
    
    private var contextSpecifier: SystemContextSpecifier { return getContextSpecifier() }
    
    // MARK: - Build Status (deprecate)
    
    /// If this SystemLayer has been built yet
    public var hasBeenBuilt: Bool = false
    
    // experimental
    //public var rhythmCueGraphByID: [String : RhythmCueGraph] = [:]
    
    /**
    Get an array of Systems, starting at a given index, and not exceeding a given maximumHeight.
    
    TODO: throws in the case of single SystemModel too large
    
    - parameter systems:       The entire reservoir of Systems from which to choose
    - parameter index:         Index of first SystemLayer in the output range
    - parameter maximumHeight: Height which is not to be exceeded by range of Systems
    
    - returns: Array of Systems fulfilling these requirements
    */
    public class func rangeFromSystemLayers(
        systems: [SystemLayer],
        startingAtIndex index: Int,
        constrainedByMaximumTotalHeight maximumHeight: CGFloat
    ) throws -> [SystemLayer]
    {
        enum SystemRangeError: ErrorType { case Error }
        
        var systemRange: [SystemLayer] = []
        var s: Int = index
        var accumHeight: CGFloat = 0
        while s < systems.count && accumHeight < maximumHeight {
            if accumHeight + systems[s].frame.height <= maximumHeight {
                systemRange.append(systems[s])
                accumHeight += systems[s].frame.height + systems[s].pad_bottom
                s++
            }
            else { break }
        }
        if systemRange.count == 0 { throw SystemRangeError.Error }
        return systemRange
    }
    
    /**
    Create a SystemLayer with a SystemViewModel

    - parameter viewModel: SystemViewModel that wraps a SystemModel and contains in it a ViewerProfile and graphical attributes

    - returns: SystemLayer
    */
    public init(viewModel: SystemViewModel) {
        self.viewModel = viewModel
        super.init()
        build()
    }
    
    /**
    Create a SystemLayer
    
    - parameter coder: NSCoder
    
    - returns: SystemLayer
    */
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    /**
    Create a SystemLayer
    
    - parameter layer: AnyObject
    
    - returns: SystemLayer
    */
    public override init(layer: AnyObject) { super.init(layer: layer) }

    // MARK: - Get information about SystemLayer
    
    /**
     Duration at a given point on horizontal axis of this SystemLayer
     
     - parameter x: Point on horizontal axis of this SystemLayer
     
     - returns: Duration at point on horizontal axis of this SystemLayer
     */
    public func durationAt(x: CGFloat) -> Duration {
        let offsetDuration = viewModel.model.durationInterval.startDuration
        if x <= infoStartX { return offsetDuration }
        if x >= frame.width { return viewModel.model.durationInterval.stopDuration }
        let infoX = round(((x - infoStartX) / viewModel.beatWidth) * 16) / 16
        let floatValue = Float(infoX)
        let duration = (
            Duration(floatValue: floatValue) + viewModel.model.durationInterval.startDuration
        )
        return duration
    }
    
    public func graphAt(graphIdentifierPath: GraphIdentifierPath) -> GraphLayer? {
        let pID = graphIdentifierPath.performerID
        let iID = graphIdentifierPath.instrumentID
        let gID = graphIdentifierPath.graphID
        return performerStratumByID[pID]?.instrumentByID[iID]?.graphByID[gID]
    }
    
    /**
    Build a SystemLayer
    */
    public func build() {
        configureViewNodeLayout()
        createMeasureViews()
        createTemporalInfoNode()
        createEventsNode()
        updateEventsNode()
    }
    
    private func updateEventsNode() {
        clearComponentNodes()
        manageBeamGroupStrata()
        managePerformerStrata()
        manageDynamicMarkingStrata()
        manageLabelStrata()
        commitComponentNodes()
        manageStems()
    }
    
    private func clearComponentNodes() {
        beamGroupStrataByPerformerID = [:]
        performerStratumByID = [:]
        dynamicMarkingNodeByPerformerID = [:]
    }
    
    private func clearStems() {
        eventsNode.sublayers?.filter { $0 is Stem }.forEach { $0.removeFromSuperlayer() }
    }
    
    // MARK: - Manage Component Nodes
    
    private func commitComponentNodes() {
        eventsNode.clearNodes()
        sortedComponentNodes().forEach { eventsNode.addNode($0) }
        eventsNode.layout()
    }
    
    public func sortedComponentNodes() -> [ViewNode] {
        let componentNodeSorter = ComponentNodeSorter(
            viewerProfile: viewModel.viewerProfile,
            sortedPerformerIDs: sortedPerformerIDs(),
            beamGroupStrataByPerformerID: beamGroupStrataByPerformerID,
            performerStratumByPerformerID: performerStratumByID,
            dynamicMarkingStratumByPerformerID: dynamicMarkingNodeByPerformerID,
            labelStratumByPerformerID: labelStratumByPerformerID
        )
        return componentNodeSorter.makeSortedComponentNodes()
    }
    
    // MARK: - Manage BeamGroupStrata
    
    private func manageBeamGroupStrata() {
        let beamGroupStrata = makeBeamGroupStrata()
        organizeBeamGroupStrataByID(beamGroupStrata)
    }
    
    private func makeBeamGroupStrata() -> [BeamGroupStratum] {
        let beamGroupStratumFactory = BeamGroupStratumFactory(
            durationNodes: viewModel.model.scoreModel.durationNodes,
            systemContextSpecifier: SystemContextSpecifier(
                viewerProfile: viewModel.viewerProfile,
                offsetDuration: viewModel.model.scoreModel.durationInterval.startDuration,
                infoStartX: infoStartX
            ),
            sizeSpecifier: StaffTypeSizeSpecifier(staffSpaceHeight: viewModel.staffSpaceHeight)
        )
        return beamGroupStratumFactory.makeBeamGroupStrataWith(viewModel.componentFilters)
    }
    
    private func organizeBeamGroupStrataByID(beamGroupStrata: [BeamGroupStratum]) {
        for bgStratum in beamGroupStrata {
            if bgStratum.instrumentIDsByPerformerID.count == 1 {
                let id = bgStratum.instrumentIDsByPerformerID.first!.0
                if beamGroupStrataByPerformerID[id] == nil {
                    beamGroupStrataByPerformerID[id] = []
                }
                beamGroupStrataByPerformerID[id]!.append(bgStratum)
            }
        }
    }
    
    // MARK: - Manage PerformerStrata
    
    private func managePerformerStrata() {
        createInstrumentEvents()
        
        // TODO: wrap
        let factory = PerformerStratumCollectionFactory(instrumentEvents: instrumentEvents)
        let performerStrata = factory.makePerformerStrata()
        organizePerformerStratumByID(performerStrata)
        
        let componentRenderer = ComponentRenderer(
            instrumentEvents: instrumentEvents,
            performerStratumByID: performerStratumByID,
            systemContextSpecifier: contextSpecifier,
            sizeSpecifier: StaffTypeSizeSpecifier(
                staffSpaceHeight: viewModel.staffSpaceHeight,
                scale: viewModel.scale
            )
        )
        componentRenderer.renderComponentsWith(viewModel.componentFilters)
        manageGraphLines()
        buildGraphs()
    }
    
    private func makePerformerStrata() -> [PerformerStratum] {
        let performerStratumFactory = PerformerStratumFactory(
            durationNodes: viewModel.model.scoreModel.durationNodes,
            instrumentTypeModel: viewModel.model.scoreModel.instrumentTypeModel
        )
        return performerStratumFactory.makePerformerStrata()
    }
    
    private func createInstrumentEvents() {
        let instrumentEventCollectionFactory = InstrumentEventCollectionFactory(
            systemModel: viewModel.model,
            systemContextSpecifier: SystemContextSpecifier(
                viewerProfile: viewModel.viewerProfile,
                offsetDuration: viewModel.model.scoreModel.durationInterval.startDuration,
                infoStartX: infoStartX
            ),
            sizeSpecifier: StaffTypeSizeSpecifier(
                staffSpaceHeight: viewModel.staffSpaceHeight,
                scale: viewModel.scale
            ),
            beatWidth: viewModel.beatWidth
        )
        self.instrumentEvents = instrumentEventCollectionFactory.makeInstrumentEvents()
    }
    
    private func manageGraphLines() {
        let graphLinesManager = SystemLayerGraphLinesManager(
            leaves: viewModel.model.scoreModel.leaves,
            measureViews: measureViews,
            performerStratumByPerformerID: performerStratumByID
        )
        graphLinesManager.manageGraphLines()
    }
    
    private func buildGraphs() {
        performerStratumByID.map { $0.1 }.forEach { $0.buildInstrumentStrata() }
    }
    
    private func organizePerformerStratumByID(performerStrata: [PerformerStratum]) {
        performerStrata.forEach { performerStratumByID[$0.identifier] = $0 }
    }
    
    private func sortedPerformerIDs() -> [PerformerID] {
        return viewModel.model.scoreModel.instrumentTypeModel.keys
    }
    
    // MARK: - Manage DynamicMarkingStrata
    
    private func manageDynamicMarkingStrata() {
        let dynamicMarkingStrata = makeDynamicMarkingStrata()
        organizeDynamicMarkingStrataByID(dynamicMarkingStrata)
    }

    private func makeDynamicMarkingStrata() -> [DynamicMarkingStratum] {
        let stratumModels = viewModel.model.scoreModel.dynamicMarkingStratumModels
        let dynamicMarkingStratumFactory = DynamicMarkingStratumFactory(
            dynamicMarkingStratumModels: stratumModels,
            systemContextSpecifier: SystemContextSpecifier(
                viewerProfile: viewModel.viewerProfile,
                offsetDuration: viewModel.model.scoreModel.durationInterval.startDuration,
                infoStartX: infoStartX
            ),
            sizeSpecifier: StaffTypeSizeSpecifier(staffSpaceHeight: viewModel.staffSpaceHeight),
            systemWidth: frame.width,
            beatWidth: viewModel.beatWidth
        )
        return dynamicMarkingStratumFactory.makeDynamicMarkingStrataFor(viewModel.componentFilters)
    }
    
    private func organizeDynamicMarkingStrataByID(dynamicMarkingStrata: [DynamicMarkingStratum]) {
        dynamicMarkingStrata.forEach { dynamicMarkingNodeByPerformerID[$0.identifier] = $0 }
    }
    
    // MARK: - Manage Labels
    
    // TODO: refactor
    private func manageLabelStrata() {
        let factory = LabelStratumFactory(
            labelStratumModels: viewModel.model.scoreModel.labelStratumModels,
            systemContextSpecifier: contextSpecifier,
            sizeSpecifier: StaffTypeSizeSpecifier(),
            systemWidth: frame.width,
            beatWidth: viewModel.beatWidth
        )
        let labelStrata = factory.makeLabelStrata()
        organizeLabelStrataByID(labelStrata)
    }
    
    private func organizeLabelStrataByID(labelStrata: [LabelStratum]) {
        labelStrata.forEach { labelStratumByPerformerID[$0.identifier] = $0 }
    }
    
    // MARK: - Manage Stems
    
    private func manageStems() {
        clearStems()
        SystemLayerStemManager(systemLayer: self).manageStems()
    }

    /**
    Add a MeasureNumber to this SystemLayer
    
    - parameter measureNumber: MeasureNumber to be added
    - parameter x:             Horizontal placement of MeasureNumber
    */
    public func addMeasureNumber(measureNumber: MeasureNumber, atX x: CGFloat) {
        temporalInfoNode.addMeasureNumber(measureNumber, atX: x)
    }
    
    /**
    Add a TimeSignature to this SystemLayer
    
    - parameter timeSignature: TimeSignature to be added
    - parameter x:             Horizontal placement of TimeSignature
    */
    public func addTimeSignature(timeSignature: TimeSignature, atX x: CGFloat) {
        temporalInfoNode.addTimeSignature(timeSignature, atX: x)
    }
    
    /**
    Add a BeamGroupStratum to this SystemLayer
    
    - parameter bgStratum: BeamGroupStratum
    */
    public func addBGStratum(bgStratum: BeamGroupStratum) {
        eventsNode.addNode(bgStratum)
    }
    
    /**
    Add a PerformerStratum to this SystemLayer
    
    - parameter performer: PerformerStratum to be added
    */
    public func addPerformer(performer: PerformerStratum) {
        performerStratumByID[performer.identifier] = performer
        eventsNode.addNode(performer)
    }

    /**
    Add a TempoMarking
    
    - parameter value:            Beats-per-minute value of Tempo
    - parameter subdivisionLevel: SubdivisionLevel (1: 1/16th note, etc)
    - parameter x:                Horizontal placement of TempoMarking
    */
    public func addTempoMarkingWithValue(value: Int,
        andSubdivisionValue subdivisionValue: Int, atX x: CGFloat
    )
    {
        temporalInfoNode.addTempoMarkingWithValue(value,
            andSubdivisionValue: subdivisionValue,
            atX: x
        )
    }
    
    /**
    Add a RehearsalMarking
    
    - parameter index: Index of the RehearsalMarking
    - parameter type:  RehearsalMarkingType (.Alphabetical, .Numerical)
    - parameter x:     Horizonatal placement of RehearsalMarking
    */
    public func addRehearsalMarkingWithIndex(index: Int,
        type: RehearsalMarkingType, atX x: CGFloat
    )
    {
        temporalInfoNode.addRehearsalMarkingWithIndex(index, type: type, atX: x)
    }
    
    // MARK: - Configure MeasureViews
    
    // Refactor MeasureView management out of here
    private func createMeasureViews() {
        self.measureViews = makeMeasureViewsWithMeasures(viewModel.model.scoreModel.measures)
        setGraphicalAttributesOfMeasureViews()
    }
    
    private func setGraphicalAttributesOfMeasureViews() {
        var accumLeft: CGFloat = infoStartX
        var accumDur: Duration = DurationZero
        for measureView in measureViews {
            measureView.system = self
            setGraphicalAttributesOfMeasureView(measureView, left: accumLeft)
            handoffTimeSignatureFromMeasureView(measureView)
            handoffMeasureNumberFromMeasureView(measureView)
            addBarlinesForMeasureView(measureView)
            accumLeft += measureView.frame.width
            accumDur += measureView.dur!
        }
    }

    private func makeMeasureViewsWithMeasures(measures: [MeasureModel]) -> [MeasureView] {
        let measureViews: [MeasureView] = measures.map { MeasureView(measure: $0) }
        return measureViews
    }
    
    private func setGraphicalAttributesOfMeasureView(measureView: MeasureView, left: CGFloat) {
        measureView.g = viewModel.staffSpaceHeight
        measureView.beatWidth = viewModel.beatWidth
        measureView.build()
        measureView.moveHorizontallyToX(left, animated: false)
    }
    
    // takes in a graphically built measure, that has been positioned within the system
    private func addBarlinesForMeasureView(measureView: MeasureView) {
        addBarlineLeftForMeasureView(measureView)
        if measureView === measureViews.last! { addBarlineRightForMeasureView(measureView) }
    }
    
    private func addBarlineLeftForMeasureView(measureView: MeasureView) {
        let barlineLeft = Barline(x: measureView.frame.minX, top: 0, bottom: frame.height)
        
        // internalize style
        barlineLeft.lineWidth = 6
        barlineLeft.strokeColor = DNMColor.grayscaleColorWithDepthOfField(.Background).CGColor
        barlineLeft.opacity = 0.75
        barlines.append(barlineLeft)
        barlinesLayer.insertSublayer(barlineLeft, atIndex: 0)
    }
    
    private func addBarlineRightForMeasureView(measureView: MeasureView) {
        let barlineRight = Barline(x: measureView.frame.maxX, top: 0, bottom: frame.height)
        
        // internalize style
        barlineRight.lineWidth = 6
        barlineRight.strokeColor = DNMColor.grayscaleColorWithDepthOfField(.Background).CGColor
        barlineRight.opacity = 0.75
        barlines.append(barlineRight)
        barlinesLayer.insertSublayer(barlineRight, atIndex: 0)
    }
    
    private func addMeasureComponentsFromMeasure(measure: MeasureView, atX x: CGFloat) {
        if let timeSignature = measure.timeSignature { addTimeSignature(timeSignature, atX: x) }
        if let measureNumber = measure.measureNumber { addMeasureNumber(measureNumber, atX: x) }
        
        // barline will become a more complex object -- barline segments, etc
        // add barlineLeft
        let barlineLeft = Barline(x: x, top: 0, bottom: frame.height)
        barlineLeft.lineWidth = 6
        barlineLeft.opacity = 0.236
        barlines.append(barlineLeft)
        insertSublayer(barlineLeft, atIndex: 0)
    }
    
    private func addBarline(barline: Barline, atX x: CGFloat) {
        barlines.append(barline)
        barline.x = x
        insertSublayer(barline, atIndex: 0)
    }
    
    /**
    Layout this SystemLayer. Calls `ViewNode.layout()`, then adjusts Ligatures.
    */
    public override func layout() {
        super.layout()
        setEventsNodeFrame()
        adjustLigatures()
    }
    
    private func setEventsNodeFrame() {
        eventsNode.frame = CGRectMake(
            eventsNode.frame.minX,
            eventsNode.frame.minY,
            self.frame.width,
            eventsNode.frame.height
        )
    }
    
    private func adjustLigatures() {
        adjustBarlines()
    }
    
    // MARK: - Utility
    
    private func sortIDs(ids: [String], withOrderedIDs orderedIDs: [String]) -> [String] {
        return sorted(ids, withReferenceArray: orderedIDs)
    }
    
    private func getInfoEndYFromGraphEvent(
        graphEvent: GraphEvent,
        withStemDirection stemDirection: StemDirection
    ) -> CGFloat
    {
        let infoEndY = stemDirection == .Down
            ? convertY(graphEvent.maxInfoY, fromLayer: graphEvent)
            : convertY(graphEvent.minInfoY, fromLayer: graphEvent)
        return infoEndY
    }
    
    private func getBeamEndYFromBGStratum(bgStratum: BeamGroupStratum) -> CGFloat {
        let beamEndY = bgStratum.viewModel.stemDirection == .Down
            ? convertY(bgStratum.beamsLayerGroup!.frame.minY, fromLayer: bgStratum)
            : convertY(bgStratum.beamsLayerGroup!.frame.maxY, fromLayer: bgStratum)
        return beamEndY
    }
    
    override func setWidthWithContents() {
        frame.size.width = measureViews.last?.frame.maxX ?? UIScreen.mainScreen().bounds.width
    }

    public func updateViewWithComponentSpans(componentFilters: ComponentFilters) {
        viewModel.componentFilters = componentFilters
        updateEventsNode()
    }
    
    // adapt ComponentFilter to ComponentTypesShownByID - DEPRECATE ONCE componentTypeShown is
    private func componentTypesShownWithIDFromComponentSpan(componentFilter: ComponentFilter)
        -> [String: [String]]
    {
        var componentTypesShownByID: [String: [String]] = [:]
        for (performerID, stateByComponentType) in componentFilter.componentTypeModel {
            for (componentType, state) in stateByComponentType {
                switch state {
                case .Show:
                    // ensure key at performerID val
                    if componentTypesShownByID[performerID] == nil {
                        componentTypesShownByID[performerID] = []
                    }
                    componentTypesShownByID[performerID]!.append(componentType)
                    
                case .Hide: break // nothing
                }
            }
        }
        return componentTypesShownByID
    }
    
    // MARK: - Manage TemporalInfoNode
    
    private func createTemporalInfoNode() {
        temporalInfoNode.pad_bottom = 0.1236 * temporalInfoNode.frame.height
        temporalInfoNode.layout()
        addNode(temporalInfoNode)
    }
    
    
    private func handoffTimeSignatureFromMeasureView(measureView: MeasureView) {
        if let timeSignature = measureView.timeSignature {
            addTimeSignature(timeSignature, atX: measureView.frame.minX)
        }
    }
    
    private func handoffMeasureNumberFromMeasureView(measureView: MeasureView) {
        if measureView.measureNumber != nil {
            addMeasureNumber(measureView.measureNumber!, atX: measureView.frame.minX)
        }
    }
    
    // MARK: - Manage Event Node
    
    private func createEventsNode() {
        addNode(eventsNode)
        eventsNode.insertSublayer(barlinesLayer, atIndex: 0)
    }
    
    // Refactor into own class: BarlineAdjuster
    private func adjustBarlines() {
        for barline in barlines {
            if let minPerformersTop = minPerformersTop,
                maxPerformersBottom = maxPerformersBottom
            {
                barline.setTop(minPerformersTop, andBottom: maxPerformersBottom)
            }
        }
    }
    
    private func getGraphEvents() -> [GraphEvent] {
        // in future: is map, forEach
        var graphEvents: [GraphEvent] = []
        for (_, performer) in performerStratumByID where eventsNode.hasNode(performer) {
            for (_, instrument) in performer.instrumentByID where performer.hasNode(instrument) {
                for (_, graph) in instrument.graphByID where instrument.hasNode(graph) {
                    for event in graph.events { graphEvents.append(event) }
                }
            }
        }
        return graphEvents.sort {$0.x < $1.x }
    }
    
    private func getMinPerformersTop() -> CGFloat? {
        if performerStratumByID.count == 0 { return 0 }
        var minY: CGFloat?
        for (_, performer) in performerStratumByID {
            if !eventsNode.hasNode(performer) { continue }
            if let minInstrumentsTop = performer.minInstrumentsTop {
                let performerTop = eventsNode.convertY(minInstrumentsTop, fromLayer: performer)
                if minY == nil { minY = performerTop }
                else if performerTop < minY! { minY = performerTop }
            }
        }
        return minY
    }
    
    private func getMaxPerformersBottom() -> CGFloat? {
        var maxY: CGFloat?
        for (_, performer) in performerStratumByID {
            if !eventsNode.hasNode(performer) { continue }
            if let maxInstrumentsBottom = performer.maxInstrumentsBottom {
                let performerBottom = eventsNode.convertY(maxInstrumentsBottom,
                    fromLayer: performer
                )
                if maxY == nil { maxY = performerBottom }
                else if performerBottom > maxY! { maxY = performerBottom }
            }
        }
        return maxY
    }
    
    private func configureViewNodeLayout() {
        stackDirectionVertical = .Top
        setsWidthWithContents = true
        pad_bottom = 2 * viewModel.staffSpaceHeight
    }
    
    private func getContextSpecifier() -> SystemContextSpecifier {
        return SystemContextSpecifier(
            viewerProfile: viewModel.viewerProfile,
            offsetDuration: viewModel.model.scoreModel.durationInterval.startDuration,
            infoStartX: infoStartX
        )
    }
    
    private func getDescription() -> String {
        return "SystemLayer: \(viewModel)"
    }
}