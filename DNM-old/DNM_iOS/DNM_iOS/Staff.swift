//
//  Staff.swift
//  DNM_iOS
//
//  Created by James Bean on 8/17/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

// TODO: update from g / s to StaffSpaceHeight and Scale
public class Staff: GraphLayer {
    
    // Size
    public var staffSpaceHeight: StaffSpaceHeight = 0
    public var s: CGFloat = 1
    public var gS: CGFloat { get { return staffSpaceHeight * s } }
    
    public var lineWidth: CGFloat { get { return 0.0618 * gS } }
    public var ledgerLineLength: CGFloat { get { return 2 * gS} }
    public var ledgerLineWidth: CGFloat { get { return 1.875 * lineWidth } }
    
    public var currentEvent: StaffEvent? { get { return events.last as? StaffEvent } }

    public init(identifier: String, staffSpaceHeight: CGFloat) {
        super.init(identifier: identifier)
        self.staffSpaceHeight = staffSpaceHeight
        configureViewNodeLayout()
    }
    
    internal override func configureViewNodeLayout() {
        pad_top = 2 * staffSpaceHeight
        pad_bottom = 2 * staffSpaceHeight
    }
    
    public override init() { super.init() }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

    public override func addEvent(event: GraphEvent) {
        guard let staffEvent = event as? StaffEvent else { return }
        events.append(staffEvent)
        addLinePointsFor(staffEvent)
    }
    
    public func addClefWithType(
        type: String,
        withTransposition transposition: Int = 0,
        atX x: CGFloat
    )
    {
        if let clefType = ClefStaffType(rawValue: type) {
            addClefWithType(clefType, withTransposition: transposition, atX: x)
        }
    }
    
    public func addClefWithType(
        type: ClefStaffType,
        withTransposition transposition: Int = 0,
        atX x: CGFloat
    )
    {
        if clefs.count > 0 && lastLinesX != nil { stopLinesAtX(x - 0.618 * gS) }
        let clef = ClefStaff.with(type,
            origin: CGPoint(x: x, y: 0),
            sizeSpecifier: StaffTypeSizeSpecifier(
                staffSpaceHeight: staffSpaceHeight,
                scale: s
            ),
            transposition: transposition
        )
        clefsLayer.addSublayer(clef)
        clefs.append(clef)
        startLinesAtX(x)
    }
    
    public func middleCPositionAtX(x: CGFloat) -> CGFloat? {
        if clefs.count == 0 { return nil }
        if let mostRecentClef = clefs.sort({$0.x < $1.x}).filter({$0.x <= x}).last as? ClefStaff {
            return mostRecentClef.middleCPosition
        }
        return nil
    }
    
    public func addPitchToCurrentEvent(pitch: Pitch) {
        guard let currentEvent = currentEvent else { return }
        currentEvent.addPitch(pitch, respellVerticality: false, andUpdateView: false)
    }
    
    public func addPitchToCurrentEvent(
        pitch pitch: Pitch,
        respellVerticality shouldRespellVerticality: Bool,
        andUpdateView shouldUpdateView: Bool
    )
    {
        assert(currentEvent != nil, "no current event")
        currentEvent?.addPitch(pitch,
            respellVerticality: shouldRespellVerticality,
            andUpdateView: shouldUpdateView
        )
    }
    
    public func addArticulationToCurrentEventWithType(type: ArticulationType) {
        assert(currentEvent != nil, "no current event")
        currentEvent?.addArticulationWithType(type)
    }
    
    public func addLedgerLinesAtX(x: CGFloat, toLevel level: Int) -> [CAShapeLayer] {
        if level == 0 { return [] }
        var ledgerLines: [CAShapeLayer] = []
        for l in 1...abs(level) {
            let y: CGFloat = level > 0 ? -CGFloat(l) * staffSpaceHeight : 4 * staffSpaceHeight + CGFloat(l) * staffSpaceHeight
            
            // TODO: wrap up
            let line = CAShapeLayer()
            let line_path = UIBezierPath()
            line_path.moveToPoint(CGPointMake(x - 0.5 * ledgerLineLength, y))
            line_path.addLineToPoint(CGPointMake(x + 0.5 * ledgerLineLength, y))
            line.path = line_path.CGPath
            line.lineWidth = ledgerLineWidth
            line.strokeColor = DNMColor.grayscaleColorWithDepthOfField(.Middleground).CGColor
            addLine(line)
            ledgerLines.append(line)
        }
        return ledgerLines
    }

    public override func build() {
        commitLines()
        commitClefs()
        commitEvents()
        setFrame()
        adjustLayersForMinY()
        hasBeenBuilt = true
    }
    
    public override func setFrame() {
        let height: CGFloat = getMaxY() - getMinY()
        let width: CGFloat = linePoints.last?.x ?? 1000
        frame = CGRectMake(left, top, width, height)
    }
    
    internal override func commitLinesFrom(left: CGFloat, to right: CGFloat) {
        for i in 0..<5 {
            let y: CGFloat = CGFloat(i) * gS
            let line: CAShapeLayer = CAShapeLayer()
            let line_path = UIBezierPath()
            line_path.moveToPoint(CGPointMake(left, y))
            line_path.addLineToPoint(CGPointMake(right, y))
            line.path = line_path.CGPath
            line.lineWidth = lineWidth
            line.strokeColor = UIColor.grayColor().CGColor
            addLine(line)
        }
    }
    
    private func commitClefs() {
        adjustClefPosition()
        addSublayer(clefsLayer)
    }
    
    private func adjustClefPosition() {
        guard let firstClef = clefs.first as? ClefStaff else { return }
        clefsLayer.position.y -= firstClef.extenderHeight
    }
    
    internal override func commitEvents() {
        events.forEach { commitEvent($0) }
        addSublayer(eventsLayer)
    }
    
    internal override func commitEvent(event: GraphEvent) {
        guard let staffEvent = event as? StaffEvent else { return }
        staffEvent.setMiddleCPosition(middleCPositionAtX(staffEvent.x))
        staffEvent.build()
        addLedgerLinesAtX(staffEvent.x, toLevel: staffEvent.amountLedgerLinesAbove)
        addLedgerLinesAtX(staffEvent.x, toLevel: staffEvent.amountLedgerLinesBelow)
        eventsLayer.addSublayer(staffEvent)
    }
    
    public override func getGraphTop() -> CGFloat {
        return eventsLayer.frame.minY
    }
    
    public override func getGraphBottom() -> CGFloat {
        return graphTop + 4 * staffSpaceHeight // hack
    }
}

public enum PlacementInStaff {
    case Line, Space, Floating
}
