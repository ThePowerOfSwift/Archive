//
//  InstrumentEventCollectionFactory.swift
//  DNM
//
//  Created by James Bean on 1/11/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public class InstrumentEventCollectionFactory: SystemContextualized {

    private let systemModel: SystemModel
    internal let viewerProfile: ViewerProfile
    internal let systemOffsetDuration: Duration
    internal let infoStartX: CGFloat
    internal let beatWidth: BeatWidth
    internal let defaultStaffHeight: StaffSpaceHeight
    internal let scale: Scale
    
    private var leafModel: DurationNodeLeafModel {
        return DurationNodeLeafModel(leaves: systemModel.scoreModel.leaves)
    }
    
    public init(
        systemModel: SystemModel,
        systemContextSpecifier: SystemContextSpecifier = SystemContextSpecifier(),
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier(),
        beatWidth: BeatWidth = 110
    )
    {
        self.systemModel = systemModel
        self.viewerProfile = systemContextSpecifier.viewerProfile
        self.systemOffsetDuration = systemContextSpecifier.offsetDuration
        self.infoStartX = systemContextSpecifier.infoStartX
        self.defaultStaffHeight = sizeSpecifier.staffSpaceHeight
        self.scale = sizeSpecifier.scale
        self.beatWidth = beatWidth
    }
    
    public func makeInstrumentEvents() -> [InstrumentEvent] {
        var instrumentEvents: [InstrumentEvent] = []
        addInstrumentEventsForLeafModelTo(&instrumentEvents)
        return instrumentEvents
    }
    
    private func addInstrumentEventsForLeafModelTo(inout resource: [InstrumentEvent]) {
        leafModel.model.forEach {
            addInstrumentEventsFor($0.0, andLeavesByInstrumentID: $0.1, toResource: &resource)
        }
    }
    
    private func addInstrumentEventsFor(performerID: PerformerID,
        andLeavesByInstrumentID leavesByInstrumentID: [InstrumentID: [DurationNode]],
        inout toResource resource: [InstrumentEvent]
    )
    {
        leavesByInstrumentID.forEach {
            addInstrumentEventsFor($0.1,
                withPerformerID: performerID,
                andInstrumentID: $0.0,
                toResource: &resource
            )
        }
    }
    
    private func addInstrumentEventsFor(leaves: [DurationNode],
        withPerformerID performerID: PerformerID,
        andInstrumentID instrumentID: InstrumentID,
        inout toResource resource: [InstrumentEvent]
    )
    {
        leaves.forEach {
            addInstrumentEventFor($0,
                withPerformerID: performerID,
                andInstrumentID: instrumentID,
                toResource: &resource
            )
        }
    }
    
    private func addInstrumentEventFor(leaf: DurationNode,
        withPerformerID performerID: PerformerID,
        andInstrumentID instrumentID: InstrumentID,
        inout toResource resource: [InstrumentEvent]
    )
    {
        guard let instrument = instrumentFor(performerID, instrumentID) else { return }
        addInstrumentEventWith(leaf, andInstrument: instrument, toResource: &resource)
    }

    private func addInstrumentEventWith(leaf: DurationNode,
        andInstrument instrument: Instrument,
        inout toResource resource: [InstrumentEvent]
    )
    {
        let instrumentEvent = InstrumentEvent.with(instrument,
            leaf: leaf,
            x: xValueAt(leaf.durationInterval.startDuration),
            width: leaf.durationInterval.duration.width(beatWidth: beatWidth),
            stemDirection: stemDirectionFor(instrument.identifierPath.performerID),
            scale: scaleFor(instrument.identifierPath.performerID)
        )
        resource.append(instrumentEvent)
    }
    
    private func instrumentFor(performerID: PerformerID, _ instrumentID: InstrumentID)
        -> Instrument?
    {
        if let instrumentType = instrumentTypeFor(performerID, instrumentID) {
            let identifierPath = InstrumentIdentifierPath(performerID, instrumentID)
            return Instrument(identifierPath: identifierPath, type: instrumentType)
        }
        return nil
    }
    
    private func instrumentTypeFor(performerID: PerformerID, _ instrumentID: InstrumentID)
        -> InstrumentType?
    {
        let instrumentTypeModel = systemModel.scoreModel.instrumentTypeModel
        return instrumentTypeModel[performerID]?[instrumentID]
    }
}