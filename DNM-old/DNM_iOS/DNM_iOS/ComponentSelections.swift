//
//  ComponentSpans.swift
//  DNM_iOS
//
//  Created by James Bean on 12/4/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel

// TODO: Conform to CollectionType for .count, etc.
/**
Sequence of type ComponentSpan. Used for user span of musical material over a
specified duration.
*/
public struct ComponentSpans: CustomStringConvertible {

    public var description: String { return getDescription() }
    
    /// DurationInterval of all ComponentSpans contained herein
    public var durationInterval: DurationInterval { return getDurationInterval() }

    /// All ComponentSpans contained herein
    public var componentSpans: [ComponentSpan] = []
    
    /// The states of each Component type, organized by PerformerID in all componentSpans
    public var componentTypeAndStatesByPerformerID: [PerformerID: [String: [Bool]]] {
        return getComponentTypeAndStateByPerformerID()
    }

    /**
    Create an empty ComponentSpans

    - returns: An empty ComponentSpans
    */
    public init() { }
    
    /**
    Create a ComponentSpans with a single ComponentSpan. For example, for use when setting the
    default ComponentSpan for the range of an entire piece.

    - parameter componentSpan: Initial ComponentSpan

    - returns: ComponentSpans with a single ComponentSpan contained
    */
    public init(componentSpan: ComponentSpan) {
        self.componentSpans = [componentSpan]
    }
    
    // TODO: break this up into several private methods
    
    public mutating func addcomponentSpan(newSpan: ComponentSpan) {
        
        // add first value
        if componentSpans.count == 0 {
            componentSpans.append(newSpan)
            return
        }
        
        // create array of overlapped sections
        var overlappedSpans: [ComponentSpan] = []
        
        var startIndex: Int?
        let startDuration = newSpan.durationInterval.startDuration
        if let startSpan = componentSpanOverlappingWithDuration(startDuration) {
            let d = newSpan.durationInterval.startDuration
            if let (firstPart, secondPart) = startSpan.bisectAtDuration(d) {
                let index = componentSpans.indexOf(startSpan)!
                replaceSpanAtIndex(index, withSpans: [firstPart, secondPart])
                
                // increment value to accomodate inserted span
                startIndex = index + 1
            }
        }
        else {
            // create replacement with durationInterval.start == componentSpan.start
        }
        
        var stopIndex: Int?
        let stopDuration = newSpan.durationInterval.stopDuration
        if let stopSpan = componentSpanOverlappingWithDuration(stopDuration) {
            let d = newSpan.durationInterval.stopDuration
            if let (firstPart, secondPart) = stopSpan.bisectAtDuration(d) {
                let index = componentSpans.indexOf(stopSpan)!
                replaceSpanAtIndex(index, withSpans: [firstPart, secondPart])
                
                // index of
                stopIndex = index + 1
            }
        }
        else {
            // create replacement with durationInterval.stop == componentSpan.stop
        }
        
        if let startIndex = startIndex, stopIndex = stopIndex {
            overlappedSpans.appendContentsOf(componentSpans[startIndex..<stopIndex])
        }
        
        // insert key/values from new span onto overlapped spans
        // wrap up in method
        var updatedSpans: [ComponentSpan] = []
        for var span in overlappedSpans {
            for (performerID, stateByComponentType) in
                newSpan.componentTypeAndStateByPerformerID
            {
                for (componentType, state) in stateByComponentType {
                    span.componentTypeAndStateByPerformerID[performerID]?[componentType] = state
                }
            }
            updatedSpans.append(span)
        }
        
        // replace spans overlapped by new span
        if let startIndex = startIndex, stopIndex = stopIndex {
            // keep testing happy for now
            if stopIndex - startIndex > 0 {
                componentSpans.removeRange(Range(start: startIndex, end: stopIndex))
                componentSpans.insertContentsOf(updatedSpans, at: startIndex)
            }
        }
        filterOutZeroDurationSpans(&componentSpans)
    }
    
    private func indexOfSpanOverlappingAtStartOfSpan(newSpan: ComponentSpan)
        -> Int?
    {
        let startDuration = newSpan.durationInterval.startDuration
        for (s, span) in componentSpans.enumerate() {
            if span.durationInterval.containsDuration(startDuration) { return s }
        }
        return nil
    }
    
    private func indexOfSpanOverlappingAtStopOfSpan(newSpan: ComponentSpan)
        -> Int?
    {
        let stopDuration = newSpan.durationInterval.stopDuration
        for (s, span) in componentSpans.enumerate() {
            if span.durationInterval.containsDuration(stopDuration) { return s }
        }
        return nil
    }
    
    private mutating func replaceSpanAtIndex(index: Int,
        withSpans spans: [ComponentSpan])
    {
        let original = componentSpans[index]
        componentSpans.insertContentsOf(spans, at: index)
        componentSpans.remove(original)
    }

    private func updateComponentTypeAndStateByPerformerIDForSpans(
        inout spans: [ComponentSpan],
        withSpan newSpan: ComponentSpan
    )
    {
        var updatedSpans: [ComponentSpan] = []
        for var overlappedSpan in spans {

            let newDict = mergeDicts(
                newSpan.componentTypeAndStateByPerformerID,
                overlappedSpan.componentTypeAndStateByPerformerID
            )
            overlappedSpan.componentTypeAndStateByPerformerID = newDict

            // add update version of overlapped span
            updatedSpans.append(overlappedSpan)
        }
    }
    
    // make generic deep nest merge of dictionary
    private func mergeDicts(d1: [PerformerID: [String: Bool]], _ d2: [PerformerID: [String: Bool]])
        -> [PerformerID: [String: Bool]]
    {
        var result: [PerformerID: [String: Bool]] = [:]
        for (performerID, stateByComponentType) in d1 {
            if result[performerID] == nil { result[performerID] = [:] }
            for (componentType, state) in stateByComponentType {
                result[performerID]!.updateValue(state, forKey: componentType)
            }
        }
        return result
    }

    private func filterOutZeroDurationSpans(inout spans: [ComponentSpan]) {
        spans = spans.filter { $0.durationInterval.duration != DurationZero }
    }
    
    public func componentSpanOverlappingWithDuration(duration: Duration)
        -> ComponentSpan?
    {
        for c in componentSpans {
            if c.durationInterval.containsDuration(duration) { return c }
        }
        return nil
    }

    private func getComponentTypeAndStateByPerformerID() -> [PerformerID: [String: [Bool]]] {
        var componentTypeAndStatesByPerformerID: [PerformerID: [String: [Bool]]] = [:]
        for span in componentSpans {
            for (performerID, statesByComponentType) in
                span.componentTypeAndStateByPerformerID
            {
                // ensure performerid key, val exists
                if componentTypeAndStatesByPerformerID[performerID] == nil {
                    componentTypeAndStatesByPerformerID[performerID] = [:]
                }
                
                for (componentType, state) in statesByComponentType {
                    
                    // ensure componenttype key, val exists
                    if componentTypeAndStatesByPerformerID[performerID]![componentType] == nil {
                        componentTypeAndStatesByPerformerID[performerID]![componentType] = []
                    }
                    
                    // add state to array
                    componentTypeAndStatesByPerformerID[performerID]![componentType]!.append(state)
                }
            }
        }
        return componentTypeAndStatesByPerformerID
    }
    
    private func getDurationInterval() -> DurationInterval {
        if componentSpans.count == 0 { return DurationIntervalZero }
        return DurationInterval.unionWithDurationIntervals(
            componentSpans.map {$0.durationInterval }
        )
    }
    
    private func getDescription() -> String {
        var description: String = "["
        for componentSpan in componentSpans {
            description += "\n\t\(componentSpan)"
        }
        description += "\n]"
        return description
    }
}

extension ComponentSpans: SequenceType {
    
    public typealias Generator = AnyGenerator<ComponentSpan>
    
    public func generate() -> Generator {
        var index = 0
        return anyGenerator {
            if index < self.componentSpans.count {
                return self.componentSpans[index++]
            }
            return nil
        }
    }
}