//
//  DurationNodeLeafModel.swift
//  DNMModel
//
//  Created by James Bean on 1/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

// TODO: conform to SequenceType?
public struct DurationNodeLeafModel {
    
    public typealias Model = [PerformerID: [InstrumentID: [DurationNode]]]
    
    public var model: Model = [:]
    
    public init() { }
    
    public init(leaves: [DurationNode]) {
        self.model = makeModelWith(leaves)
    }
    
    public func leavesAt(identifierPath: InstrumentIdentifierPath) -> [DurationNode]? {
        return model[identifierPath.performerID]?[identifierPath.instrumentID]
    }

    // takes in a rich DurationNode, splits it up and sorts it
    public mutating func addLeaf(leaf: DurationNode) {
        let organizer = DurationNodeLeafOrganizer(leaves: [leaf])
        let organized = organizer.leavesByInstrumentIDByPerformerID
        model = model.mergeWith(organized)
    }
    
    public mutating func addLeaf(leaf: DurationNode,
        withInstrumentIdentifierPath identifierPath: InstrumentIdentifierPath
    )
    {
        model.safelyAppend(leaf, toArrayWithKeyPath: identifierPath)
    }
    
    // filter with ComponentFilter
    
    // TODO: implement
    public func filteredBy(componentFilters: ComponentFilters) -> DurationNodeLeafModel {
        
        return self
    }
    
    private func makeModelWith(leaves: [DurationNode]) -> Model {
        let organizer = DurationNodeLeafOrganizer(leaves: leaves)
        return organizer.leavesByInstrumentIDByPerformerID
    }
}

extension DurationNodeLeafModel: CustomStringConvertible {
    
    public var description: String {
        var result = "{"
        for (performerID, leavesByInstrumentID) in model {
            result += "\n\t\(performerID):"
            for (instrumentID, leaves) in leavesByInstrumentID {
                result += "\n\t\t\(instrumentID):"
                for leaf in leaves {
                    result += "\n\t\t\t\(leaf)"
                }
            }
        }
        result += "\n}"
        return result
    }
}