//
//  ComponentFilters.swift
//  DNMModel
//
//  Created by James Bean on 12/31/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

// TODO: Conform to CollectionType for .count, etc.
/**
Structures that determine DurationIntervals in which to show or hide given ComponentTypes
*/
public struct ComponentFilters {
    
    /// DurationInterval of all ComponentFilters contained herein
    public var durationInterval: DurationInterval { return getDurationInterval() }
    
    /// All ComponentFilters contained herein
    public var componentFilters: [ComponentFilter] = []
    
    /// All of the ComponentTypeStates for each ComponentType, throughout all ComponentFilters
    public var componentTypeMultipleStateModel: ComponentTypeMultipleStateModel {
        return getStatesByComponentTypeByPerformerID()
    }
    
    /**
     Create an empty ComponentFilters
     
     - returns: An empty ComponentFilters
     */
    public init() { }
    
    /**
    Create a ComponentFilters with an array of ComponentFilters

    - parameter componentFilters: Multiple ComponentFilters

    - returns: ComponentFilters
    */
    public init(componentFilters: [ComponentFilter]) {
        self.componentFilters = componentFilters
    }
    
    /**
    Create a ComponentFilters with a single ComponentFilter. For example, for use when setting the
    default ComponentFilter for the range of an entire piece.

    - parameter componentFilter: Initial ComponentFilter

    - returns: ComponentFilters with a single ComponentFilter contained
    */
    public init(componentFilter: ComponentFilter) {
        self.componentFilters = [componentFilter]
    }
    
    /**
    Get the ComponentFilters in a given DurationInterval. Trims the first and last to match the
    startDuration and stopDuration of the DurationInterval. A slice.

    - parameter durationInterval: DurationInterval

    - returns: ComponentFilters
    */
    public func componentFiltersIn(durationInterval: DurationInterval) -> ComponentFilters {
        var filtersOverlapped = componentFiltersOverlappedByDurationInterval(durationInterval)
        switch filtersOverlapped.componentFilters.count {
        case 0:
            return ComponentFilters(componentFilters: [])
        default:
            filtersOverlapped.trimFirstToDuration(durationInterval.startDuration)
            filtersOverlapped.trimLastToDuration(durationInterval.stopDuration)
            return filtersOverlapped
        }
    }
    
    /**
     Get the ComponentFilters that are overlapped by a given DurationInterval
     
     - parameter durationInterval: DurationInterval
     
     - returns: ComponentFilters
     */
    public func componentFiltersOverlappedByDurationInterval(durationInterval: DurationInterval)
        -> ComponentFilters
    {
        let start = indexOfcomponentFilterOverlappingWithDuration(durationInterval.startDuration)
        let stop = indexOfcomponentFilterOverlappingWithDuration(durationInterval.stopDuration)
        if let start = start, stop = stop {
            let overlappedFilters: [ComponentFilter] = Array(componentFilters[start...stop])
            let filters = ComponentFilters(componentFilters: overlappedFilters)
            return filters
        }
        else if let start = start {
            let filters = ComponentFilters(componentFilters:
                Array(componentFilters[start..<componentFilters.count])
            )
            return filters
        }
        return ComponentFilters(componentFilters: [])
    }
    
    private mutating func trimFirstToDuration(duration: Duration) {
        var first = componentFilters.first!
        first.durationInterval.trimStartDurationTo(durationInterval.startDuration)
        componentFilters.replaceFirstWith(first)
    }
    
    private mutating func trimLastToDuration(duration: Duration) {
        var last = componentFilters.last!
        last.durationInterval.trimStopDurationTo(durationInterval.stopDuration)
        componentFilters.replaceLastWith(last)
    }
    
    private func indexOfcomponentFilterOverlappingWithDuration(duration: Duration) -> Int? {
        for (s, filter) in componentFilters.enumerate() {
            if filter.durationInterval.contains(duration) { return s }
        }
        return nil
    }
    
    // TODO: break this up into several private methods
    // TODO: guard against making a selection out of bounds
    public mutating func addComponentFilter(newFilter: ComponentFilter) {
        
        // add first value
        if componentFilters.count == 0 {
            componentFilters.append(newFilter)
            return
        }
        
        // create array of overlapped sections
        var overlappedFilters: [ComponentFilter] = []
        
        var startIndex: Int?
        let startDuration = newFilter.durationInterval.startDuration
        if let startFilter = componentFilterOverlappingWithDuration(startDuration) {
            let d = newFilter.durationInterval.startDuration
            if let (firstPart, secondPart) = startFilter.bisectAtDuration(d) {
                let index = componentFilters.indexOf(startFilter)!
                replaceFilterAtIndex(index, withFilters: [firstPart, secondPart])
                
                // increment value to accomodate inserted filter
                startIndex = index + 1
            }
        }
        else {
            // TODO: guard against making a selection out of bounds
        }
        
        var stopIndex: Int?
        let stopDuration = newFilter.durationInterval.stopDuration
        if let stopFilter = componentFilterOverlappingWithDuration(stopDuration) {
            let d = newFilter.durationInterval.stopDuration
            if let (firstPart, secondPart) = stopFilter.bisectAtDuration(d) {
                let index = componentFilters.indexOf(stopFilter)!
                replaceFilterAtIndex(index, withFilters: [firstPart, secondPart])
                
                // index of
                stopIndex = index + 1
            }
        }
        else {
            // TODO: guard against making a selection out of bounds
        }
        
        if let startIndex = startIndex, stopIndex = stopIndex {
            overlappedFilters.appendContentsOf(componentFilters[startIndex..<stopIndex])
        }
        
        // insert key/values from new filter onto overlapped filters
        // wrap up in method
        var updatedFilters: [ComponentFilter] = []
        for var filter in overlappedFilters {
            for (performerID, stateByComponentType) in newFilter.componentTypeModel {
                for (componentType, state) in stateByComponentType {
                    filter.componentTypeModel[performerID]?[componentType] = state
                }
            }
            updatedFilters.append(filter)
        }
        
        // replace filters overlapped by new filter
        if let startIndex = startIndex, stopIndex = stopIndex {
            // keep testing happy for now
            if stopIndex - startIndex > 0 {
                componentFilters.removeRange(Range(start: startIndex, end: stopIndex))
                componentFilters.insertContentsOf(updatedFilters, at: startIndex)
            }
        }
        filterOutZeroDurationFilters(&componentFilters)
    }
    
    private func indexOfFilterOverlappingAtStartOfFilter(newFilter: ComponentFilter)
        -> Int?
    {
        let startDuration = newFilter.durationInterval.startDuration
        for (s, filter) in componentFilters.enumerate() {
            if filter.durationInterval.contains(startDuration) { return s }
        }
        return nil
    }
    
    private func indexOfFilterOverlappingAtStopOfFilter(newFilter: ComponentFilter)
        -> Int?
    {
        let stopDuration = newFilter.durationInterval.stopDuration
        for (s, filter) in componentFilters.enumerate() {
            if filter.durationInterval.contains(stopDuration) { return s }
        }
        return nil
    }
    
    private mutating func replaceFilterAtIndex(index: Int,
        withFilters filters: [ComponentFilter])
    {
        let original = componentFilters[index]
        componentFilters.insertContentsOf(filters, at: index)
        componentFilters.remove(original)
    }
    
    private func updateComponentTypeAndStateByPerformerIDForFilters(
        inout filters: [ComponentFilter],
        withFilter newFilter: ComponentFilter
    )
    {
        var updatedFilters: [ComponentFilter] = []
        for var overlappedFilter in filters {
            let newDict = mergeDicts(
                newFilter.componentTypeModel,
                newFilter.componentTypeModel
            )
            overlappedFilter.componentTypeModel = newDict
            updatedFilters.append(overlappedFilter)
        }
    }
    
    // make generic deep nest merge of dictionary
    private func mergeDicts(d1: ComponentTypeModel, _ d2: ComponentTypeModel)
        -> ComponentTypeModel
    {
        var result: ComponentTypeModel = [:]
        for (performerID, stateByComponentType) in d1 {
            if result[performerID] == nil { result[performerID] = [:] }
            for (componentType, state) in stateByComponentType {
                result[performerID]!.updateValue(state, forKey: componentType)
            }
        }
        return result
    }
    
    private func filterOutZeroDurationFilters(inout filters: [ComponentFilter]) {
        filters = filters.filter { $0.durationInterval.duration != DurationZero }
    }
    
    public func componentFilterOverlappingWithDuration(duration: Duration)
        -> ComponentFilter?
    {
        for c in componentFilters {
            if c.durationInterval.contains(duration) { return c }
        }
        return nil
    }
    
    private func getStatesByComponentTypeByPerformerID() -> ComponentTypeMultipleStateModel {
        var result: ComponentTypeMultipleStateModel = [:]
        componentFilters.forEach {
            for (performerID, stateByComponentType) in $0.componentTypeModel {
                
                // ensure value at key exists
                if result[performerID] == nil { result[performerID] = [:] }
                
                for (componentType, state) in stateByComponentType {
                    
                    // ensure value at key exists
                    if result[performerID]![componentType] == nil {
                        result[performerID]![componentType] = []
                    }
                    
                    if !result[performerID]![componentType]!.contains(state) {
                        result[performerID]![componentType]!.append(state)
                    }
                }
            }
        }
        return result
    }
    
    private func getDurationInterval() -> DurationInterval {
        if componentFilters.count == 0 { return DurationIntervalZero }
        return DurationInterval.unionWithDurationIntervals(
            componentFilters.map {$0.durationInterval }
        )
    }
}

// MARK: - CustomStringConvertible
extension ComponentFilters: CustomStringConvertible {
    
    /// String representation of ComponentFilters
    public var description: String {
        var result: String = "["
        componentFilters.forEach { result += "\n\t\($0)"}
        result += "\n]"
        return result
    }
}

// MARK: - SequenceType
extension ComponentFilters: SequenceType {
    
    public typealias Generator = AnyGenerator<ComponentFilter>
    
    public func generate() -> Generator {
        var index = 0
        return anyGenerator {
            if index < self.componentFilters.count {
                return self.componentFilters[index++]
            }
            return nil
        }
    }
}