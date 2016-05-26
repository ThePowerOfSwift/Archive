//
//  ScoreModelComponentTypeOrganizer.swift
//  DNMModel
//
//  Created by James Bean on 12/29/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

// TODO: Generalize this to ComponentOrganizer
public class ScoreModelComponentTypeOrganizer {
    
    private let scoreModel: ScoreModel
    
    public init(scoreModel: ScoreModel) {
        self.scoreModel = scoreModel
    }
    
    public func componentTypesByPerformerID() -> [PerformerID: [ComponentType]] {
        var componentTypesByPerformerID: [PerformerID: [ComponentType]] = [:]
        addComponentTypesFor(scoreModel.durationNodes, toResource: &componentTypesByPerformerID)
        return componentTypesByPerformerID
    }
    
    private func addComponentTypesFor(durationNodes: [DurationNode],
        inout toResource resource: [PerformerID: [ComponentType]]
    )
    {
        durationNodes.forEach { addComponentTypesFor($0, toResource: &resource) }
    }
    
    private func addComponentTypesFor(durationNode: DurationNode,
        inout toResource resource: [PerformerID: [ComponentType]]
    )
    {
        for (performerID, componentTypes) in durationNode.componentTypesByPerformerID {
            let allTypes = ["rhythm"] + componentTypes
            addComponentTypes(allTypes, withPerformerID: performerID, toResource: &resource)
        }
    }
    
    private func addComponentTypes(componentTypes: [ComponentType],
        withPerformerID performerID: PerformerID,
        inout toResource resource: [PerformerID: [ComponentType]]
    )
    {
        componentTypes.forEach {
            resource.safelyAndUniquelyAppend($0, toArrayWithKey: performerID)
        }
    }
}