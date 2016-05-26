//
//  SystemLayerStemManager.swift
//  DNM_iOS
//
//  Created by James Bean on 12/30/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel

/**
 Creates and inserts Stems connecting BeamGroupEvents and, if available, InstrumentEvents
 */
public struct SystemLayerStemManager {
    
    private let systemLayer: SystemLayer
    
    /**
    Create a SystemLayerStemManager

    - parameter systemLayer: SystemLayer

    - returns: SystemLayerStemManager
    */ 
    public init(systemLayer: SystemLayer) {
        self.systemLayer = systemLayer
    }
    
    /**
    Create and insert Stems connecting BeamGroupEvents and, if available, InstrumentEvents
    */
    public func manageStems() {
        systemLayer.beamGroupStrataByPerformerID.forEach {
            manageStemsFor($0.1, withPerformerID: $0.0)
        }
    }
    
    private func manageStemsFor(beamGroupStrata: [BeamGroupStratum],
        withPerformerID performerID: PerformerID
    )
    {
        if let beamGroupStratum = beamGroupStrata.first {
            manageStemsFor(beamGroupStratum, withPerformerID: performerID)
        }
    }
    
    private func manageStemsFor(beamGroupStratum: BeamGroupStratum,
        withPerformerID performerID: PerformerID
    )
    {
        beamGroupStratum.beamGroupEvents.forEach {
            manageStemFor($0, withPerformerID: performerID)
        }
    }
    
    private func manageStemFor(beamGroupEvent: BeamGroupEvent,
        withPerformerID performerID: PerformerID
    )
    {
        let instrumentEvent = instrumentEventFor(beamGroupEvent, withPerformerID: performerID)
        let stemHandler = stemHandlerFor(beamGroupEvent, instrumentEvent)
        let stem = stemHandler.makeStemIn(systemLayer.eventsNode)
        commitStem(stem)
    }
    
    private func commitStem(stem: Stem) {
        systemLayer.eventsNode.insertSublayer(stem, atIndex: 1) // above barlines
    }
    
    private func stemHandlerFor(beamGroupEvent: BeamGroupEvent,
        _ instrumentEvent: InstrumentEvent?
    ) -> StemHandler
    {
        return StemHandler(beamGroupEvent: beamGroupEvent, instrumentEvent: instrumentEvent)
    }
    
    private func instrumentEventFor(beamGroupEvent: BeamGroupEvent,
        withPerformerID performerID: PerformerID
    ) -> InstrumentEvent?
    {
        func durationIntervalMatch(instrumentEvent: InstrumentEvent) -> Bool {
            let beamGroupEventDurationInterval = beamGroupEvent.durationNode.durationInterval
            let instrumentEventDurationInterval = instrumentEvent.leaf.durationInterval
            return beamGroupEventDurationInterval == instrumentEventDurationInterval
        }
        
        func performerIDMatch(instrumentEvent: InstrumentEvent) -> Bool {
            return instrumentEvent.instrument.identifierPath.performerID == performerID
        }
        
        for instrumentEvent in systemLayer.instrumentEvents {
            if durationIntervalMatch(instrumentEvent) && performerIDMatch(instrumentEvent) {
                return instrumentEvent
            }
        }
        return nil
    }

}