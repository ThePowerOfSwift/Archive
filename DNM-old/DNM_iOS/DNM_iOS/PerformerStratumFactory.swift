//
//  PerformerStratumFactory.swift
//  DNM_iOS
//
//  Created by James Bean on 12/22/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel

public class PerformerStratumFactory {
    
    private let durationNodes: [DurationNode]
    private let instrumentTypeModel: InstrumentTypeModel
    
    private var performerStratumByID: [PerformerID: PerformerStratum] = [:]
    
    public init(
        durationNodes: [DurationNode],
        instrumentTypeModel: InstrumentTypeModel
    )
    {
        self.durationNodes = durationNodes
        self.instrumentTypeModel = instrumentTypeModel
    }
    
    // TODO: inject ComponentFilters: Only create Performer / Instruments for components present
    public func makePerformerStrata() -> [PerformerStratum] {
        durationNodes.forEach { createPerformerStrataWith($0) }
        return performerStratumByID.map { $0.1 }
    }
    
    private func createPerformerStrataWith(durationNode: DurationNode) {
        for (performerID, instrumentIDs) in durationNode.instrumentIDsByPerformerID {
            createPerformerStratumWithPerformerID(performerID,
                andInstrumentIDs: instrumentIDs
            )
        }
    }
    
    private func createPerformerStratumWithPerformerID(performerID: PerformerID,
        andInstrumentIDs instrumentIDs: [InstrumentID]
    )
    {
        let instrumentTypeByInstrumentID = instrumentTypeByInstrumentIDWithPerformerID(
            performerID, andInstrumentIDs: instrumentIDs
        )
        ensurePerformerStratumWith(performerID)
        if let performerStratum = performerStratumByID[performerID] {
            performerStratum.addInstrumentsWithInstrumentTypeByInstrumentID(
                instrumentTypeByInstrumentID
            )
        }
    }

    private func ensurePerformerStratumWith(performerID: PerformerID) {
        if performerStratumByID[performerID] == nil {
            let performerStratum = PerformerStratum(identifier: performerID)
            performerStratumByID[performerID] = performerStratum
            // TODO: set pad internally
            performerStratum.pad_bottom = 10 // hack
        }
    }
    
    private func instrumentTypeByInstrumentIDWithPerformerID(performerID: PerformerID,
        andInstrumentIDs instrumentIDs: [InstrumentID]
    ) -> OrderedDictionary<InstrumentID, InstrumentType>
    {
        var instrumentTypeByInstrumentID = OrderedDictionary<InstrumentID, InstrumentType>()
        instrumentIDs.forEach {
            setInstrumentTypeForPerformerID(performerID,
                andInstrumentID: $0,
                toResource: &instrumentTypeByInstrumentID
            )
        }
        return instrumentTypeByInstrumentID
    }
    
    private func setInstrumentTypeForPerformerID(performerID: PerformerID,
        andInstrumentID instrumentID: InstrumentID,
        inout toResource resource: OrderedDictionary<InstrumentID, InstrumentType>
    )
    {
        let typeByID = instrumentTypeModel
        if let instrumentType = typeByID[performerID]?[instrumentID] {
            resource[instrumentID] = instrumentType
        }
    }
}