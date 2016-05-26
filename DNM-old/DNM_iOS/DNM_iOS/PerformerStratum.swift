//
//  PerformerStratum.swift
//  DNM_iOS
//
//  Created by James Bean on 8/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

/**
A single System's worth of music notation for a single Performer.
Contains 0...n InstrumentStrata, which are automatically positioned in order.
*/
public class PerformerStratum: ViewNode {

    /// String representation of this PerformerStratum
    public override var description: String {
        return "PerformerStratum: ID: \(identifier); instrumentByID: \(instrumentByID)"
    }
    
    /// Identifier of this PerformerStratum
    public var identifier: String!
    
    /// The order in which InstrumentStrata shall appear
    public var instrumentOrder: [InstrumentID]?
    
    // TODO: implement instrumentByID as OrderedDictionary
    /// InstrumentStrata organized by InstrumentID
    public var instrumentByID: [InstrumentID : InstrumentStratum] = [:]
    
    /// Bracket on left of PerformerStratum
    public var bracket: CAShapeLayer?
    
    // TODO: Implement richer SystemItemLabel(view(model)), holding ViewerProfile
    /// Text label displaying PerformerID
    public var label: TextLayerConstrainedByHeight?
    
    /** Top of the highest GraphLayer in the contained InstrumentStrata.
    E.g., in the case of a Staff, the GraphLayer.graphTop may be different from the top of the 
    Layer, as there may be musical information with ledger lines, etc.
    */
    public var minInstrumentsTop: CGFloat? { get { return getMinInstrumentsTop() } }
    
    /** Bottom of the lowest GraphLayer in the contained InstrumentStrata.
    E.g., in the case of a Staff, the GraphLayer.graphBottom may be different from the bottom of the
    Layer, as there may be musical information with ledger lines, etc.
    */
    public var maxInstrumentsBottom: CGFloat? { get { return getMaxInstrumentsBottom() } }
    
    /**
    Create a PerformerStratum

    - parameter identifier: Identifier of this PerformerStratum

    - returns: PerformerStratum
    */
    public init(identifier: String) {
        super.init()
        self.identifier = identifier
        configureViewNodeLayout()
        addLabel()
    }
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    
    /**
    Get the InstrumentEvent at a given horizontal position, if available.
    
    - parameter x: Horizontal position of desired InstrumentEvent
    
    - returns: InstrumentEvent at a given horizontal position, if available.
    */
    public func instrumentEventAt(x: CGFloat) -> InstrumentEvent? {
        if let firstInstrumentStratum = instrumentByID.first?.1 {
            return firstInstrumentStratum.instrumentEventAt(x)
        }
        return nil
    }
    
    /**
    Instruct all InstrumentStrata to instruct all contained Graphs to stop lines at a given
    horizontal position

    - parameter x: Horizontal position at which to stop GraphLayer lines
    */
    public func stopAllLinesAt(x: CGFloat) {
        instrumentByID.map { $0.1 }.forEach { $0.stopAllLinesAt(x) }
    }
    
    /**
    Instruct all InstrumentStrata to build all contained Graphs
    */
    public func buildInstrumentStrata() {
        instrumentByID.forEach { $0.1.build() }
    }
    
    /**
    Add an InstrumentStratum

    - parameter instrument: InstrumentStratum to add
    */
    public func addInstrument(instrument: InstrumentStratum) {
        instrumentByID[instrument.identifier] = instrument
        addNode(instrument)
        instrument.performer = self
        instrument.pad_bottom = 20 // hack
    }
    
    /**
    Add an InstrumentStratum with a given InstrumentType and InstrumentID

    - parameter instrumentTypeByInstrumentID: OrderedDictionary of InstrumentTypes organized
    by InstrumentID
    */
    public func addInstrumentsWithInstrumentTypeByInstrumentID(
        instrumentTypeByInstrumentID: OrderedDictionary<InstrumentID, InstrumentType>)
    {
        for (instrumentID, instrumentType) in instrumentTypeByInstrumentID {
            createInstrumentWithInstrumentType(instrumentType, andID: instrumentID)
        }
    }
    
    /**
    Create an InstrumentStratum with a given InstrumentType and InstrumentID. 
    Will not override a preexisting InstrumentStratum for the speicified identifier.

    - parameter instrumentType: InstrumentType of the InstrumentStratum
    - parameter id:             InstrumentID of the InstrumentStratum
    */
    public func createInstrumentWithInstrumentType(instrumentType: InstrumentType,
        andID identifier: String
    )
    {
        if instrumentByID[identifier] == nil {
            if let instrument = InstrumentStratum.withType(instrumentType) {
                instrument.identifier = identifier
                instrument.pad_bottom = 20 // HACK
                addInstrument(instrument)
            }
        }
    }
    
    /**
    Layout this PerformerStratum. Positions InstrumentStrata in order, and manages Bracket.
    */
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
        guard let top = minInstrumentsTop, bottom = maxInstrumentsBottom else { return }
        bracket.path = makeBracketPath(top: top, bottom: bottom)
        setVisualAttributesFor(bracket)
        positionLabel(top: top, bottom: bottom)
    }
    
    private func makeBracketPath(top top: CGFloat, bottom: CGFloat) -> CGPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, top))
        path.addLineToPoint(CGPointMake(0, bottom))
        return path.CGPath
    }
    
    private func setVisualAttributesFor(bracket: CAShapeLayer) {
        bracket.strokeColor = DNMColor.grayscaleColorWithDepthOfField(.MiddleBackground).CGColor
        bracket.lineWidth = 3
    }
    
    // MARK: - Manage Label
    
    private func addLabel() {
        label = TextLayerConstrainedByHeight(
            text: identifier,
            x: -10,
            top: 0,
            height: 10,
            alignment: .Right,
            fontName: "Baskerville-SemiBold"
        )
        label!.foregroundColor = DNMColor.grayscaleColorWithDepthOfField(.MostForeground).CGColor
        addSublayer(label!)
    }
    
    private func positionLabel(top top: CGFloat, bottom: CGFloat) {
        label?.position.y = top + 0.5 * (bottom - top)
    }
    
    // MARK: - Bracket dimensions
    
    private func getMinInstrumentsTop() -> CGFloat? {
        let instruments = instrumentByID.map { $0.1 }.filter { hasNode($0) }.filter {
            $0.minGraphsTop != nil
        }
        return instruments.map { convertY($0.minGraphsTop!, fromLayer: $0) }.sort(<).first
    }
    
    private func getMaxInstrumentsBottom() -> CGFloat? {
        let instruments = instrumentByID.map { $0.1 }.filter { hasNode($0) }.filter {
            $0.maxGraphsBottom != nil
        }
        return instruments.map { convertY($0.maxGraphsBottom!, fromLayer: $0) }.sort(>).first
    }
    
    // TODO: make pad_bottom dynamic
    private func configureViewNodeLayout() {
        pad_bottom = 20
        pad_top = 20
        stackDirectionVertical = .Top
    }
}