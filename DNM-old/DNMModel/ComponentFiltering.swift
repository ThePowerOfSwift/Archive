//
//  ComponentFiltering.swift
//  DNMModel
//
//  Created by James Bean on 12/31/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public protocol ComponentFiltering {
    
    var durationNodes: [DurationNode] { get }
    
    func composeLeavesByComponentTypeFor(componentFilters: ComponentFilters)
        -> [ComponentType: [DurationNode]]
    
    func sortLeaves(leaves: [DurationNode]) -> [DurationNode]
}

extension ComponentFiltering {
    
    /**
    Sort array of DurationNode leaves by DurationInterval startDuration

    - parameter leaves: Array of DurationNode leaves

    - returns: Array of DurationNode leaves sorted by DurationInterval startDuration
    */
    public func sortLeaves(leaves: [DurationNode]) -> [DurationNode] {
        return leaves.sort {
            $0.durationInterval.startDuration < $1.durationInterval.startDuration
        }
    }
    
    /**
    Compose a Dictionary of arrays of DurationNode leaves organized by ComponentType.
    E.g., one may want to have all DurationNode leaves containing Pitch Components, with all
    other Components filtered out.

    - parameter componentFilters: Structures that dictate DurationIntervals in which to show
    or hide different ComponentTypes

    - returns: Dictionary of arrays of DurationNode leaves organized by ComponentType
    */
    public func composeLeavesByComponentTypeFor(componentFilters: ComponentFilters)
        -> [ComponentType: [DurationNode]]
    {
        var result: [ComponentType: [DurationNode]] = [:]
        componentFilters.forEach { addLeavesShownFor($0, toResource: &result) }
        return result
    }
    
    func addLeavesShownFor(componentFilter: ComponentFilter,
        inout toResource resource: [ComponentType: [DurationNode]]
        )
    {
        var leavesByComponentType: [ComponentType: [DurationNode]] = [:]
        for (performerID, componentTypes) in componentFilter.componentTypesShownByPerformerID {
            addLeavesShownFor(componentFilter,
                withPerformerID: performerID,
                andComponentTypes: componentTypes,
                toResource: &leavesByComponentType
            )
        }
        mergeLeavesByComponentType(leavesByComponentType, withResource: &resource)
    }
    
    func mergeLeavesByComponentType(leavesByComponentType: [ComponentType: [DurationNode]],
        inout withResource resource: [ComponentType: [DurationNode]]
    )
    {
        for (componentType, leaves) in leavesByComponentType {
            addLeaves(leaves, withComponentType: componentType, toResource: &resource)
        }
    }
    
    func addLeaves(leaves: [DurationNode],
        withComponentType componentType: ComponentType,
        inout toResource resource: [ComponentType: [DurationNode]]
    )
    {
        resource.safelyAppendContentsOf(leaves, toArrayWithKey: componentType)
    }
    
    func addLeavesShownFor(componentFilter: ComponentFilter,
        withPerformerID performerID: PerformerID,
        andComponentTypes componentTypes: [ComponentType],
        inout toResource resource: [ComponentType: [DurationNode]]
    )
    {
        componentTypes.forEach {
            addLeavesShownFor(componentFilter,
                withPerformerID: performerID,
                andComponentType: $0,
                toResource: &resource
            )
        }
    }
    
    func addLeavesShownFor(componentFilter: ComponentFilter,
        withPerformerID performerID: PerformerID,
        andComponentType componentType: ComponentType,
        inout toResource resource: [ComponentType: [DurationNode]]
    )
    {
        let leaves = leavesApplicableTo(componentFilter, performerID, componentType)
        resource.safelyAppendContentsOf(leaves, toArrayWithKey: componentType)
    }
    
    func leavesApplicableTo(componentFilter: ComponentFilter,
        _ performerID: PerformerID,
        _ componentType: ComponentType
    ) -> [DurationNode]
    {
        var leaves = durationNodes.map { $0.copy() }
        leaves = leavesFrom(leaves, inComponentSpan: componentFilter)
        leaves = leavesFrom(leaves, withComponentType: componentType)
        leaves = leavesFrom(leaves, withPerformerID: performerID)
        leaves = filterOutAllComponentsButThoseWithType(componentType, fromLeaves: leaves)
        return leaves
    }
    
    func filterOutAllComponentsButThoseWithIdentifier(identifier: String,
        fromLeaves leaves: [DurationNode]
    ) -> [DurationNode]
    {
        return leaves.map {
            let replacement = $0.copy()
            replacement.components = $0.components.filter { $0.identifier == identifier }
            return replacement
        }
    }
    
    func filterOutAllComponentsButThoseWithType(type: ComponentType,
        fromLeaves leaves: [DurationNode]
    ) -> [DurationNode]
    {
        return leaves.map {
            let replacement = $0.copy()
            replacement.components = $0.components.filter { $0.type == type }
            return replacement
        }
    }
    
    func leavesFrom(leaves: [DurationNode], withPerformerID performerID: PerformerID)
        -> [DurationNode]
    {
        return leaves.filter { $0.hasComponentWithPerformerID(performerID) }
    }
    
    func leavesFrom(leaves: [DurationNode], withComponentType componentType: ComponentType)
        -> [DurationNode]
    {
        return leaves.filter { $0.hasComponentWithType(componentType) }
    }
    
    func leavesFrom(leaves: [DurationNode], withComponentIdentifier identifier: String)
        -> [DurationNode]
    {
        return leaves.filter { $0.hasComponentWithIdentifier(identifier) }
    }
    
    func leavesFrom(leaves: [DurationNode], inComponentSpan componentFilter: ComponentFilter)
        -> [DurationNode]
    {
        return leaves.filter {
            componentFilter.durationInterval.contains($0.durationInterval.startDuration)
        }
    }
    
    func leavesFrom(leaves: [DurationNode],
        inDurationInterval durationInterval: DurationInterval
    ) -> [DurationNode]
    {
        return leaves.filter {
            durationInterval.contains($0.durationInterval.startDuration)
        }
    }
}