//
//  GraphLayer.swift
//  DNM_iOS
//
//  Created by James Bean on 8/17/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

/// GraphLayer
public class GraphLayer: ViewNode, BuildPattern {

    /// Identifier of GraphLayer
    public var identifier: String = ""

    /// The InstrumentStratum containing this GraphLayer, if present
    public var instrument: InstrumentStratum?
    
    /// Distance from top eventsLayer to actual top of GraphLayer (always >= 0)
    public var graphTop: CGFloat { get { return getGraphTop() } }
    
    /// Distance from bottom of eventsLayer to actual top of GraphLayer (aways <= frame.height)
    public var graphBottom: CGFloat { get { return getGraphBottom() } }
    
    /// GraphEvents contained by this GraphLayer
    internal var events: [GraphEvent] = []

    /// Height of GraphLayer
    internal var height: CGFloat = 0

    // MARK: - Manage GraphLines
    
    // TODO: change name of LineActions to something else (enum LinePoint)

    /// Clefs contained by this GraphLayer
    internal var clefs: [Clef] = []
    
    internal var lines: [CAShapeLayer] = []
    
    internal var linePoints: [GraphLinePoint] = []
    
    internal var lastLinesX: CGFloat?
    
    internal var linesLayer: CALayer = CALayer()
    internal var clefsLayer: CALayer = CALayer()
    internal var eventsLayer: CALayer = CALayer()
    
    public var hasBeenBuilt: Bool = false
    
    public class func withType(graphType: GraphType) -> GraphLayer? {
        switch graphType {
        case .Staff: return Staff()
        case .Waveform: return GraphWaveform()
        default: return nil
        }
    }
    
    /**
    Create a GraphLayer

    - parameter identifier: Identifier of GraphLayer

    - returns: GraphLayer
    */
    public init(identifier: String) {
        super.init()
        self.identifier = identifier
    }
    
    internal func configureViewNodeLayout() {
        pad_top = 20
        pad_bottom = 20
    }
    
    public override init() { super.init() }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public func addClefAtX(x: CGFloat) {
        let clef = Clef(origin: CGPoint(x: x, y: 0))
        clef.build()
        addClef(clef)
    }
    
    public func addClef(clef: Clef) {
        clefs.append(clef)
        clef.position.y = 0.5 * frame.height
        clefsLayer.addSublayer(clef)
        startLinesAtX(clef.x)
    }
    
    public func addEvent(event: GraphEvent) {
        events.append(event)
        addLinePointsFor(event)
    }
    
    internal func addLinePointsFor(event: GraphEvent) {
        switch event {
        case is GraphEventRest:
            stopLinesAtX(event.x)
        default:
            startLinesAtX(event.x)
            stopLinesAtX(event.x + event.width)
        }
    }
    
    public func getEventAtX(x: CGFloat) -> GraphEvent? {
        for event in events { if event.x == x { return event } }
        return nil
    }
    
    public func startLinesAtX(x: CGFloat) {
        linePoints.append(GraphLinePointStart(x: x))
        lastLinesX = x
    }
    
    public func stopLinesAtX(x: CGFloat) {
        linePoints.append(GraphLinePointStop(x: x))
        lastLinesX = nil
    }
    
    public func build() {
        commitLines()
        commitClefs()
        commitEvents()
        setFrame()
        adjustLayersForMinY()
        hasBeenBuilt = true
    }
    
    internal func commitEvents() {
        events.forEach { commitEvent($0) }
        addSublayer(eventsLayer)
    }
    
    internal func commitEvent(event: GraphEvent) {
        event.build()
        eventsLayer.addSublayer(event)
    }

    public func commitLines() {
        sortLinePoints()
        createLines()
        addSublayer(linesLayer)
    }
    
    private func commitClefs() {
        addSublayer(clefsLayer)
    }
    
    internal func createLines() {
        var lastPointX: CGFloat?
        for linePoint in linePoints {
            switch linePoint {
            case is GraphLinePointStart:
                if lastPointX == nil { lastPointX = linePoint.x }
            default:
                if let left = lastPointX {
                    let right = linePoint.x
                    commitLinesFrom(left, to: right)
                    lastPointX = nil
                }
            }
        }
    }
    
    internal func commitLinesFrom(left: CGFloat, to right: CGFloat) {
        let line = makeLineFrom(left, to: right)
        addLine(line)
    }
    
    private func makeLineFrom(left: CGFloat, to right: CGFloat) -> CAShapeLayer {
        let line = CAShapeLayer()
        line.path = makePathForLineFrom(left, to: right)
        setVisualAttributesForLine(line)
        return line
    }
    
    private func makePathForLineFrom(left: CGFloat, to right: CGFloat) -> CGPath {
        let linePath = UIBezierPath()
        linePath.moveToPoint(CGPoint(x: left, y: 0))
        linePath.addLineToPoint(CGPoint(x: right, y: 0))
        return linePath.CGPath
    }
    
    private func setVisualAttributesForLine(line: CAShapeLayer) {
        line.lineWidth = 1
        line.strokeColor = DNMColor.grayscaleColorWithDepthOfField(.MiddleBackground).CGColor
    }
    
    internal func addLine(line: CAShapeLayer) {
        lines.append(line)
        linesLayer.addSublayer(line)
    }
    
    private func sortLinePoints() {
        linePoints.sortInPlace {
            let firstRounded = round($0.x * 10) / 10
            let secondRounded = round($1.x * 10) / 10
            if firstRounded == secondRounded { return $0 is GraphLinePointStop }
            return firstRounded < secondRounded
        }
    }
    
    internal func addLabel() {
        let h: CGFloat = 20  // hack
        let label = TextLayerConstrainedByHeight(
            text: identifier,
            x: 0,
            top: 10,
            height: h,
            alignment: PositionAbsolute.Right
        )
        addSublayer(label)
    }
    
    internal func getMaxY() -> CGFloat {
        return events.map { $0.maxY }.maxElement() ?? 0
    }
    
    internal func getMinY() -> CGFloat {
        return events.map { $0.minY }.minElement() ?? 0
    }
    
    public func getGraphTop() -> CGFloat {
        // override
        return 0
    }
    
    public func getGraphBottom() -> CGFloat {
        // override
        return height
    }
    
    public func setFrame() {
        let width: CGFloat = 1000
        let height = getMaxY() - getMinY()
        frame = CGRectMake(left, top, width, height)
    }
    
    internal func adjustLayersForMinY() {
        linesLayer.position.y -= getMinY()
        eventsLayer.position.y -= getMinY()
        clefsLayer.position.y -= getMinY()
    }
    
    public override func setWidthWithContents() {
        // potentially something here
        super.setWidthWithContents()
    }
}

public enum GraphType {
    case Staff, ContinuousController, Switch, Waveform
}

