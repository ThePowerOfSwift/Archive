//
//  InstrumentStratum.swift
//  DNM_iOS
//
//  Created by James Bean on 8/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

/**
A single System's worth of music notation for a single Instrument.
Contains 0...n Graphs, which are automatically positioned in order.
*/
public class InstrumentStratum: ViewNode {

    public override var description: String { return getDescription() }
    
    /// Identifier of this InstrumentStratum
    public var identifier: String!

    /// InstrumentType of the Insrument for whose music is displayed by this InstrumentStratum
    public var instrumentType: InstrumentType?
    
    /// PerformerStratum that contains this InstrumentStratum
    public var performer: PerformerStratum?
    
    /// The InstrumentEvents contained by this InstrumentStratum
    public var instrumentEvents: [InstrumentEvent] = []
    
    /// The order in which Graphs shall appear
    public var graphOrder: [GraphID] = []
    
    // TODO: implement graphByID as OrderedDictionary
    /// Graphs organized by GraphID
    public var graphByID: [GraphID: GraphLayer] = [:]
    
    /// The default Graphs shown for a given InstrumentStratum
    public var primaryGraphs: [GraphLayer] = []
    
    /// Supplementary Graphs shown for a given InstrumentStratum
    public var supplementaryGraphs: [GraphLayer] = []
    
    /// Bracket on left of InstrumentStratum
    public var bracket: CAShapeLayer? // make subclass
    
    // TODO: Implement richer SystemItemLabel(view(model)), holding ViewerProfile
    /// Text label displaying InstrumentID, if necessary.
    public var label: TextLayerConstrainedByHeight?

    /** Top of the highest GraphLayer in the contained Graphs.
    E.g., in the case of a Staff, the GraphLayer.graphTop may be different from the top of the
    Layer, as there may be musical information with ledger lines, etc.
    */
    public var minGraphsTop: CGFloat? { get { return getMinGraphsTop() } }
    
    /** Bottom of the lowest GraphLayer in the contained Graphs.
    E.g., in the case of a Staff, the GraphLayer.graphBottom may be different from the bottom of the
    Layer, as there may be musical information with ledger lines, etc.
    */
    public var maxGraphsBottom: CGFloat? { get { return getMaxGraphsBottom() } }
    
    // TODO: create custom subclasses for InstrumentFamilies outside of Strings
    /**
    Create an InstrumentStratum with InstrumentType
    
    - parameter instrumentType: InstrumentType of the InstrumentStratum
    
    - returns: InstrumentStratum, if possible
    */
    public class func withType(instrumentType: InstrumentType) -> InstrumentStratum? {
        if instrumentType.isInInstrumentFamily(Strings) {
            let instrument = InstrumentString()
            instrument.instrumentType = instrumentType
            return instrument
        }
        else {
            let instrument = InstrumentStratum()
            instrument.instrumentType = instrumentType
            return instrument
        }
    }

    /**
    Create an InstrumentStratum

    - parameter identifier: Identifier of the InstrumentStratum

    - returns: InstrumentStratum
    */
    public init(identifier: InstrumentID) {
        super.init(stackVerticallyFrom: .Top)
        self.identifier = identifier
    }
    
    /**
    Create an InstrumentStratum

    - returns: InstrumentStratum
    */
    public override init() {
        super.init(stackVerticallyFrom: .Top)
    }
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    
    public func addInstrumentEvent(instrumentEvent: InstrumentEvent) {
        instrumentEvents.append(instrumentEvent)
    }
    
    public func build() {
        createGraphs()
        populateGraphsWithEvents()
        buildGraphs()
        layout()
    }

    private func createGraphs() {
        instrumentEvents.forEach { ensureGraphFor($0) }
    }
    
    private func populateGraphsWithEvents() {
        instrumentEvents.forEach { populateGraphsWith($0) }
    }
    
    private func populateGraphsWith(instrumentEvent: InstrumentEvent) {
        instrumentEvent.graphEvents.forEach { populateGraphsWith($0) }
    }
    
    private func populateGraphsWith(graphEvent: GraphEvent) {
        guard let graph = graphByID[graphEvent.identifier] else { return }
        graph.addEvent(graphEvent)
    }
    
    internal func buildGraphs() {
        graphByID.forEach { $0.1.build() }
    }
    
    private func ensureGraphFor(instrumentEvent: InstrumentEvent) {
        guard !(instrumentEvent is InstrumentEventRest) else { return }
        instrumentEvent.graphEvents.forEach { ensureGraphFor($0) }
    }

    private func ensureGraphFor(graphEvent: GraphEvent) {
        if graphByID[graphEvent.identifier] == nil {
            switch graphEvent {
            case let staffEvent as StaffEvent:
                let staffSpaceHeight = staffEvent.staffSpaceHeight
                let staff = Staff(
                    identifier: staffEvent.identifier, staffSpaceHeight: staffSpaceHeight
                )
                
                // TODO: get best suited clef for content
                let clefType = staffEvent.clefContext?.type ?? .Treble
                staff.addClefWithType(clefType, atX: staffEvent.x - 35)
                addGraph(staff)
            default:
                let graph = GraphLayer(identifier: graphEvent.identifier)
                graph.addClefAtX(graphEvent.x - 35)
                addGraph(graph)
            }
        }
    }

    /**
    Get the InstrumentEvent at a given horizontal position, if available.

    - parameter x: Horizontal position of desired InstrumentEvent

    - returns: InstrumentEvent at a given horizontal position, if available.
    */
    public func instrumentEventAt(x: CGFloat) -> InstrumentEvent? {
        let roundedXToCompare = round(x * 10) / 10
        for instrumentEvent in instrumentEvents {
            let roundedX = round(instrumentEvent.x * 10 ) / 10
            if roundedXToCompare == roundedX { return instrumentEvent }
        }
        return nil
    }
    
    /**
    Instruct all Graphs to stop lines at a given horizontal position

    - parameter x: Horizontal position at which to stop GraphLayer lines
    */
    public func stopAllLinesAt(x: CGFloat) {
        graphByID.map { $0.1 }.forEach { $0.stopLinesAtX(x) }
    }

    
    /**
    Add a GraphLayer

    - parameter graph:     GraphLayer
    - parameter isPrimary: If this GraphLayer is a primary GraphLayer
    */
    public func addGraph(graph: GraphLayer, isPrimary: Bool = true) {
        graphByID[graph.identifier] = graph
        isPrimary ? primaryGraphs.append(graph) : supplementaryGraphs.append(graph)
        
        // TODO: internalize
        graph.pad_bottom = 5 // hack
        graph.instrument = self
        if primaryGraphs.containsObject(graph) { addNode(graph) }
    }
    
    public override func layout() {
        super.layout()
        manageBracket()
    }
    
    // MARK: - Manage Bracket
    
    private func manageBracket() {
        bracket == nil ? createBracket() : configureBracket()
    }

    private func createBracket() {
        bracket = CAShapeLayer()
        addSublayer(bracket!)
    }
    
    private func configureBracket() {
        guard let bracket = bracket else { return }
        guard let top = minGraphsTop, bottom = maxGraphsBottom else { return }
        bracket.path = makeBracketPath(top: top, bottom: bottom)
        setVisualAttributesFor(bracket)
    }
    
    // TODO: make x value dynamic
    private func makeBracketPath(top top: CGFloat, bottom: CGFloat) -> CGPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(6, top))
        path.addLineToPoint(CGPointMake(6, bottom))
        return path.CGPath
    }
    
    private func setVisualAttributesFor(bracket: CAShapeLayer) {
        bracket.strokeColor = DNMColor.grayscaleColorWithDepthOfField(.MiddleBackground).CGColor
        bracket.lineWidth = 3
    }
    
    private func getMinGraphsTop() -> CGFloat? {
        let graphTopValues = graphByID.map { $0.1 }.filter { hasNode( $0) }
        return graphTopValues.map { convertY($0.graphTop, fromLayer: $0) }.sort(<).first
    }
    
    private func getMaxGraphsBottom() -> CGFloat? {
        let graphBottomValues = graphByID.map { $0.1 }.filter { hasNode($0) }
        return graphBottomValues.map { convertY($0.graphBottom, fromLayer: $0) }.sort(>).first
    }
    
    internal func getDescription() -> String {
        return "\(identifier): \(graphByID)"
    }
}