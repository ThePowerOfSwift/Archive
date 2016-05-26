//
//  DynamicMarkingStratumModelArranger.swift
//  DNMModel
//
//  Created by James Bean on 12/31/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
 Arranges DynamicMarkingStratumModels for unorganized DurationNodes
 */
public struct DynamicMarkingStratumModelArranger: ComponentFiltering {
    
    public let durationNodes: [DurationNode]
    
    public init(durationNodes: [DurationNode]) {
        self.durationNodes = durationNodes
    }
    
    // shows all
    public func makeDynamicMarkingStratumModels() -> [DynamicMarkingStratumModel] {
        let leavesByPerformerID = organizeLeavesByPerformerID(durationNodes)
        let stratumModels = composeDynamicMarkingStratumModelsWith(leavesByPerformerID)
        return stratumModels
    }
    
    // shows only specified by ComponentFilters
    public func makeDynamicMarkingStratumModelsFor(componentFilters: ComponentFilters)
        -> [DynamicMarkingStratumModel]
    {
        let leavesByPerformerID = orgnizeLeavesByPerformerIDWith(componentFilters)
        let stratumModels = composeDynamicMarkingStratumModelsWith(leavesByPerformerID)
        return stratumModels
    }
    
    private func orgnizeLeavesByPerformerIDWith(componentFilters: ComponentFilters)
        -> [PerformerID: [DurationNode]]
    {
        let leavesByComponentType = composeLeavesByComponentTypeFor(componentFilters)
        let dynamicsLeaves = leavesWithDynamicMarkingComponentsFrom(leavesByComponentType)
        return organizeLeavesByPerformerID(dynamicsLeaves)
    }
    
    private func organizeLeavesByPerformerID(leaves: [DurationNode])
        -> [PerformerID: [DurationNode]]
    {
        var result: [PerformerID: [DurationNode]] = [:]
        leaves.forEach {
            if let performerID = $0.components.first?.instrumentIdentifierPath.performerID {
                if result[performerID] == nil { result[performerID] = [] }
                result[performerID]!.append($0)
            }
        }
        return result
    }
    
    private func composeDynamicMarkingStratumModelsWith(
        leavesByPerformerID: [PerformerID: [DurationNode]]
    ) -> [DynamicMarkingStratumModel]
    {
        var stratumModels: [DynamicMarkingStratumModel] = []
        for (performerID, leaves) in leavesByPerformerID {
            let stratumModel = dynamicMarkingStratumModelFor(leaves,
                withPerformerID: performerID
            )
            stratumModels.append(stratumModel)
        }
        return stratumModels
    }
    
    private func dynamicMarkingStratumModelFor(leaves: [DurationNode],
        withPerformerID performerID: PerformerID
    ) -> DynamicMarkingStratumModel
    {
        let leaves = sortLeaves(leaves)
        var stratumModel = DynamicMarkingStratumModel(identifier: performerID)
        addDynamicMarkingElementsFrom(leaves, toStratumModel: &stratumModel)
        return stratumModel
    }
    
    private func leavesWithDynamicMarkingComponentsFrom(
        leavesByComponentType: [ComponentType: [DurationNode]]
    ) -> [DurationNode]
    {
        if let dynamicsLeaves = leavesByComponentType["dynamics"] {
            return filterOutAllComponentsButThoseWithType("dynamics",
                fromLeaves: dynamicsLeaves
            )
        }
        return []
    }

    private func addDynamicMarkingElementsFrom(leaves: [DurationNode],
        inout toStratumModel stratumModel: DynamicMarkingStratumModel
    )
    {
        leaves.forEach { addDynamicMarkingElementsFrom($0, toStratumModel: &stratumModel) }
    }
    
    private func addDynamicMarkingElementsFrom(leaf: DurationNode,
        inout toStratumModel stratumModel: DynamicMarkingStratumModel
    )
    {
        let (dynamicMarkingModel, shouldCommitSpanner) = dynamicMarkingElementContextFrom(leaf)
        commitDynamicMarkingElements(
            dynamicMarking: dynamicMarkingModel,
            whileCommittingSpanner: shouldCommitSpanner,
            toStratumModel: &stratumModel
        )
    }
    
    private func dynamicMarkingElementContextFrom(leaf: DurationNode)
        -> (DynamicMarkingModel?, Bool)
    {
        var shouldCommitSpanner = false
        var dynamicMarkingModel: DynamicMarkingModel?
        
        for component in leaf.components {
            switch component {
            case let marking as ComponentDynamicMarking:
                dynamicMarkingModel = dynamicMarkingModelAt(
                    leaf.durationInterval.startDuration,
                    withStringValue: marking.value
                )
            case is ComponentDynamicMarkingSpannerStop: shouldCommitSpanner = true
            default: break
            }
        }
        return (dynamicMarkingModel, shouldCommitSpanner)
    }
    
    private func dynamicMarkingModelAt(duration: Duration, withStringValue stringValue: String)
        -> DynamicMarkingModel
    {
        return DynamicMarkingModel(
            stringValue: stringValue,
            durationInterval: DurationInterval(duration: DurationZero, startDuration: duration)
        )
    }
    
    private func commitDynamicMarkingElements(
        dynamicMarking dynamicMarkingModel: DynamicMarkingModel?,
        whileCommittingSpanner shouldCommitSpanner: Bool,
        inout toStratumModel stratumModel: DynamicMarkingStratumModel
        )
    {
        if let dynamicMarkingModel = dynamicMarkingModel {
            switch shouldCommitSpanner {
            case true: stratumModel.addSpannerWith(dynamicMarkingModel)
            case false: stratumModel.add(dynamicMarkingModel)
            }
        }
    }
}