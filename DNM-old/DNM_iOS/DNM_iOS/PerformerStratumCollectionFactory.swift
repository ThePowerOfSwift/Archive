//
//  PerformerStratumCollectionFactory.swift
//  DNM
//
//  Created by James Bean on 1/13/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

public class PerformerStratumCollectionFactory {
    
    private let instrumentEvents: [InstrumentEvent]
    
    private var performerStratumByID: [PerformerID: PerformerStratum] = [:]
    
    public init(instrumentEvents: [InstrumentEvent]) {
        self.instrumentEvents = instrumentEvents
    }
    
    public func makePerformerStrata() -> [PerformerStratum] {
        instrumentEvents.forEach { prepareStratumHierarchyFor($0) }
        return performerStratumByID.map { $0.1 }
    }
    
    private func prepareStratumHierarchyFor(instrumentEvent: InstrumentEvent) {
        ensureStratumHierarchyFor(instrumentEvent.instrument)
    }
    
    private func ensureStratumHierarchyFor(instrument: Instrument) {
        let identifierPath = instrument.identifierPath
        let performerStratum = ensurePerformerStratumFor(identifierPath.performerID)
        ensureInstrumentStratumFor(instrument, inPerformerStratum: performerStratum)
    }

    private func ensurePerformerStratumFor(performerID: PerformerID) -> PerformerStratum {
        if performerStratumByID[performerID] == nil {
            let performerStratum = PerformerStratum(identifier: performerID)
            performerStratumByID[performerID] = performerStratum
        }
        return performerStratumByID[performerID]!
    }
    
    private func ensureInstrumentStratumFor(instrument: Instrument,
        inPerformerStratum performerStratum: PerformerStratum
    )
    {
        performerStratum.createInstrumentWithInstrumentType(instrument.type,
            andID: instrument.identifierPath.instrumentID
        )
    }
}