//
//  DynamicMarkingStratumModel.swift
//  DNMModel
//
//  Created by James Bean on 12/28/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

// TODO: Conform to a protocol: ComponentSpannerStratum (has: Nodes, Edges)
/**
Model of a stratum of DynamicMarkings
*/
public struct DynamicMarkingStratumModel {
    
    /// Identifier fo DynamicMarkingStratumModel
    public var identifier: PerformerID
    
    /// Array of DynamicMarkingModels and DynamicMarkingSpannerModels in order
    public var dynamicMarkingElementModels: [DynamicMarkingElementModel] = []

    /// Array of DynamicMarkingModels
    public var dynamicMarkingModels: [DynamicMarkingModel] = []
    
    /// Array of DynamicMarkingSpannerModels
    public var dynamicMarkingSpannerModels: [DynamicMarkingSpannerModel] = []
    
    private var lastDynamicMarking: DynamicMarkingModel? { return getLastDynamicMarking() }
    private var penultimateDynamicMarking: DynamicMarkingModel? {
        return getPenultimateDynamicMarking()
    }
    
    /**
    Create a DynamicMarkingStratumModel

    - returns: DynamicMarkingStratumModel
    */
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    public func dynamicMarkingStratumModelIn(durationInterval: DurationInterval)
        -> DynamicMarkingStratumModel
    {
        let replicator = DynamicMarkingStratumModelReplicator(dynamicMarkingStratumModel: self)
        return replicator.replicateIn(durationInterval)
    }
    
    public mutating func updateElementModels() {
        clearElementModels()
        dynamicMarkingModels.forEach { dynamicMarkingElementModels.append($0) }
        dynamicMarkingSpannerModels.forEach { dynamicMarkingElementModels.append($0) }
        sortElementModels()
    }
    
    private mutating func sortElementModels() {
        dynamicMarkingElementModels.sortInPlace {
            ($0.durationInterval.startDuration + $0.durationInterval.stopDuration) / 2 <
            ($1.durationInterval.startDuration + $1.durationInterval.stopDuration) / 2
        }
    }
    
    public mutating func clearElementModels() {
        dynamicMarkingElementModels = []
    }
    
    /**
    Add a DynamicMarking model

    - parameter dynamicMarkingModel: DynamicMarkingModel to add
    */
    public mutating func add(dynamicMarkingModel: DynamicMarkingModel) {
        self.dynamicMarkingModels.append(dynamicMarkingModel)
        updateElementModels()
    }

    /**
    Add a DynamicMarkingSpanner model

    - parameter dynamicMarkingSpannerModel: DynamicMarkingSpannerModel to add
    */
    public mutating func add(dynamicMarkingSpannerModel: DynamicMarkingSpannerModel) {
        self.dynamicMarkingSpannerModels.append(dynamicMarkingSpannerModel)
        updateElementModels()
    }
    
    /**
    Add a new DynamicMarking, which completes a DynamicMarkingSpanner

    - parameter newDynamicMarking: DynamicMarking to add
    */
    public mutating func addSpannerWith(newDynamicMarking: DynamicMarkingModel) {
        if let lastDynamicMarking = lastDynamicMarking {
            let spannerModel = spannerModelSpanning(lastDynamicMarking, newDynamicMarking)
            add(spannerModel)
            add(newDynamicMarking)
        }
    }
    
    /**
    Insert a DynamicMarkingSpanner between two DynamicMarkings

    - parameter firstDynamicMarking:  DynamicMarking from which to begin DynamicMarkingSpanner
    - parameter secondDynamicMarking: DynamicMarking at which to stop DynamicMarkingSpanner
    */
    public mutating func insertSpannerFrom(firstDynamicMarking: DynamicMarkingModel,
        to secondDynamicMarking: DynamicMarkingModel
    )
    {
        if let indexOfFirst = dynamicMarkingElementModels.indexOf(firstDynamicMarking) {
            let spannerModel = spannerModelSpanning(firstDynamicMarking, secondDynamicMarking)
            dynamicMarkingElementModels.insert(spannerModel, atIndex: indexOfFirst + 1)
        }
    }
    
    public mutating func insertSpannerBeforeLastDynamicMarking() {
        guard dynamicMarkingModels.count > 1 else { return }
        insertSpannerFrom(penultimateDynamicMarking!, to: lastDynamicMarking!)
    }
    
    public func dynamcMarkingAt(duration: Duration) -> DynamicMarkingModel? {
        for dynamicMarkingModel in dynamicMarkingModels {
            if dynamicMarkingModel.durationInterval.startDuration == duration {
                return dynamicMarkingModel
            }
        }
        return nil
    }
    
    public func dynamicMarkingSpannerStartingAt(duration: Duration)
        -> DynamicMarkingSpannerModel?
    {
        for dynamicMarkingSpannerModel in dynamicMarkingSpannerModels {
            if dynamicMarkingSpannerModel.durationInterval.startDuration == duration {
                return dynamicMarkingSpannerModel
            }
        }
        return nil
    }
    
    public func dynamicMarkingSpannerStoppingAt(duration: Duration)
        -> DynamicMarkingSpannerModel?
    {
        for dynamicMarkingSpannerModel in dynamicMarkingSpannerModels {
            if dynamicMarkingSpannerModel.durationInterval.stopDuration == duration {
                return dynamicMarkingSpannerModel
            }
        }
        return nil
    }
    
    private func getLastDynamicMarking() -> DynamicMarkingModel? {
        return dynamicMarkingModels.last
    }
    
    private func getPenultimateDynamicMarking() -> DynamicMarkingModel? {
        return dynamicMarkingModels.penultimate
    }

    private func spannerModelSpanning(firstDynamicMarking: DynamicMarkingModel,
        _ secondDynamicMarking: DynamicMarkingModel
    ) -> DynamicMarkingSpannerModel
    {
        return DynamicMarkingSpannerModel(
            direction: spannerDirectionFor(firstDynamicMarking, secondDynamicMarking),
            durationInterval: durationIntervalFor(firstDynamicMarking, secondDynamicMarking)
        )
    }
    
    private func durationIntervalFor(firstDynamicMarking: DynamicMarkingModel,
        _ secondDynamicMarking: DynamicMarkingModel
    ) -> DurationInterval
    {
        return DurationInterval.unionWithDurationIntervals([
            firstDynamicMarking.durationInterval, secondDynamicMarking.durationInterval
        ])
    }
    
    private func spannerDirectionFor(firstDynamicMarking: DynamicMarkingModel,
        _ secondDynamicMarking: DynamicMarkingModel
    ) -> DynamicMarkingSpannerDirection
    {
        if let startValue = firstDynamicMarking.finalNumericalValue,
            let stopValue = secondDynamicMarking.initialNumericalValue
        {
            switch (startValue, stopValue) {
            case _ where startValue > stopValue: return .Decrescendo
            case _ where startValue < stopValue: return .Crescendo
            default: return .Static
            }
        }
        return .Static
    }
}

extension DynamicMarkingStratumModel: CustomStringConvertible {
    
    public var description: String {
        var result: String = ""
        for (e, elementModel) in dynamicMarkingElementModels.enumerate() {
            if e > 0 { result += " " }
            result += "\(elementModel)"
        }
        return result
    }
}
