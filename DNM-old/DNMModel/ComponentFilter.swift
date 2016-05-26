//
//  ComponentFilter.swift
//  DNMModel
//
//  Created by James Bean on 12/31/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

// TODO: change to DurationSpanningComponentFilterCollection
/**
Collection of which musical information to render in a given DurationInterval
*/
public struct ComponentFilter: DurationSpanning, Equatable, CustomStringConvertible {
    
    /// String representation of a ComponentFilter
    public var description: String { return getDescription() }
    
    /// The DurationInterval for which to render the desired musical information
    public var durationInterval: DurationInterval
    
    /// State for each componentType for each performerID
    public var componentTypeModel: ComponentTypeModel = [:]
    
    public var componentTypesShownByPerformerID: [PerformerID: [ComponentType]] {
        return getComponentTypesShownByPerformerID()
    }

    /**
    Create a ComponentFilter with a DurationInterval
    - parameter durationInterval: DurationInterval for which to render the desired musical information

    - returns: ComponentFilter with empy componentTypeAndStateByPerformerID data
    */
    public init(durationInterval: DurationInterval) {
        self.durationInterval = durationInterval
    }
    
    /**
     Show a ComponentType for a given PerformerID
     
     - parameter componentType: ComponentType to show
     - parameter performerID:   PerformerID for which to show the ComponentType
     */
    public mutating func showComponentType(componentType: ComponentType,
        forPerformerID performerID: PerformerID
    )
    {
        componentTypeModel[performerID]?[componentType] = .Show
    }
    
    /**
     Hide a ComponentType for a given PerformerID
     
     - parameter componentType: ComponentType to hide
     - parameter performerID:   PerformerID for which to hide the ComponentType
     */
    public mutating func hideComponentType(componentType: ComponentType,
        forPerformerID performerID: PerformerID
    )
    {
        componentTypeModel[performerID]?[componentType] = .Hide
    }
    
    public func showsComponentType(componentType: ComponentType,
        forPerformerID performerID: PerformerID
    ) -> Bool
    {
        return componentTypeModel[performerID]?[componentType] == .Show
    }
    
    public func hidesComponentType(componentType: ComponentType,
        forPerformerID performerID: PerformerID
    ) -> Bool
    {
        return componentTypeModel[performerID]?[componentType] == .Hide
    }
    
    /**
     Get the IntervalRelationship to another ComponentFilter
     - parameter componentFilter: Another ComponentFilter
     - returns: IntervalReleationship to another ComponentFilter
     */
    public func relationshipToComponentSpan(componentFilter: ComponentFilter)
        -> IntervalRelationship
    {
        return durationInterval.relationshipToDurationInterval(componentFilter.durationInterval)
    }
    
    /**
     Create another ComponentFilter, with a new DurationInterval.
     The componentTypeAndStateByPerformerID data is retained.
     - parameter durationInterval: New DurationInterval
     - returns: New ComponentFilter with new DurationInterval, but same data
     */
    public func copyWithNewDurationInterval(durationInterval: DurationInterval)
        -> ComponentFilter
    {
        var componentFilter = self
        componentFilter.durationInterval = durationInterval
        return componentFilter
    }
    
    /**
     Create two ComponentFilters, each with the same data as this ComponentFilter, though with
     DurationIntervals up until, and after a Duration of bisection. May be nil.
     - parameter duration: Duration at which to bisect
     - returns: Two ComponentFilters, potentially
     */
    public func bisectAtDuration(duration: Duration)
        -> (ComponentFilter, ComponentFilter)?
    {
        guard let (a, b) = durationInterval.bisectAtDuration(duration) else { return nil }
        let firstSpan = copyWithNewDurationInterval(a)
        let secondSpan = copyWithNewDurationInterval(b)
        return (firstSpan, secondSpan)
    }
    
    private func getComponentTypesShownByPerformerID() -> [PerformerID: [ComponentType]] {
        var result: [PerformerID: [ComponentType]] = [:]
        for (performerID, stateByComponentType) in componentTypeModel {
            for (componentType, state) in stateByComponentType where state == .Show {
                if result[performerID] == nil { result[performerID] = [] }
                result[performerID]!.append(componentType)
            }
        }
        return result
    }
    
    private func getDescription() -> String {
        var description: String = ""
        description += "\(durationInterval)"
        description += "; componentTypes: \(componentTypeModel)"
        return description
    }
}

/**
 Check equivalence of two ComponentFilters
 - parameter lhs: ComponentFilter
 - parameter rhs: ComponentFilter
 - returns: If two ComponentFilters are equivalent
 */
public func == (lhs: ComponentFilter, rhs: ComponentFilter) -> Bool {
    return lhs.durationInterval == rhs.durationInterval &&
        lhs.componentTypeModel == rhs.componentTypeModel
}