//
//  DurationNodeLeafOrganizer.swift
//  DNMModel
//
//  Created by James Bean on 1/11/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class DurationNodeLeafOrganizer {
    
    private let leaves: [DurationNode]

    public var leavesByInstrumentIDByPerformerID: [PerformerID: [InstrumentID: [DurationNode]]]
    {
        return getLeavesByInstrumentIDByPerformerID()
    }
    
    public init(leaves: [DurationNode]) {
        self.leaves = leaves
    }
    
    private func getLeavesByInstrumentIDByPerformerID()
        -> [PerformerID: [InstrumentID: [DurationNode]]]
    {
        var result: [PerformerID: [InstrumentID: [DurationNode]]] = [:]
        leaves.forEach { organizeLeaf($0, intoResource: &result) }
        return result
    }
    
    private func organizeLeaf(leaf: DurationNode,
        inout intoResource resource: [PerformerID: [InstrumentID: [DurationNode]]]
    )
    {
        leaf.componentModel.forEach {
            organizeLeaf(leaf,
                withComponentsByInstrumentID: $0.1,
                withPerformerID: $0.0,
                intoResource: &resource
            )
        }
    }
    
    private func organizeLeaf(leaf: DurationNode,
        withComponentsByInstrumentID componentsByInstrumentID: [InstrumentID: [Component]],
        withPerformerID performerID: PerformerID,
        inout intoResource resource: [PerformerID: [InstrumentID: [DurationNode]]]
    )
    {
        componentsByInstrumentID.forEach {
            let identifierPath = InstrumentIdentifierPath(performerID, $0.0)
            let filteredLeaf = leaf.copyWithComponentsFor(identifierPath)
            resource.safelyAndUniquelyAppend(filteredLeaf,
                toArrayWithKeyPath: identifierPath
            )
        }
    }
}