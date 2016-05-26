//
//  DurationInterval.swift
//  DNMModel
//
//  Created by James Bean on 11/27/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public struct DurationInterval: Equatable, CustomStringConvertible {
    
    public var description: String { get { return getDescription() } }
    
    /// Duration starting this DurationInterval
    public var startDuration: Duration = DurationZero { didSet { setDuration() } }
    
    /// Duration stopping this DurationInterval
    public var stopDuration: Duration = DurationZero { didSet { setDuration() } }
    
    /// Span of this DurationInterval
    public var duration: Duration = DurationZero
    
    // TODO: test, make private static getter
    public static func unionWithDurationIntervals(durationIntervals: [DurationInterval])
        -> DurationInterval
    {
        let start = durationIntervals.sort {
            $0.startDuration < $1.startDuration
        }.first!.startDuration
        
        let stop = durationIntervals.sort {
            $0.stopDuration > $1.stopDuration
        }.first!.stopDuration
        
        return DurationInterval(startDuration: start, stopDuration: stop)
    }
    
    /**
    Create a DurationInterval

    - returns: DurationIntervalZero
    */
    public init() { }
    
    /**
    Create a DurationInterval with two Durations, which do not have to be in order.

    - parameter duration:      One Duration
    - parameter otherDuration: Another Duration

    - returns: DurationInterval
    */
    public init(oneDuration: Duration,
        andAnotherDuration otherDuration: Duration
    )
    {
        let durations: [Duration] = [oneDuration, otherDuration].sort(<)
        self.startDuration = durations.first!
        self.stopDuration = durations.last!
        self.duration = stopDuration - startDuration
    }
    
    /**
    Create a DurationInterval with two Durations (the first being before the second)

    - parameter startDuration: Duration to start the DurationInterval
    - parameter stopDuration:  Duration to stop the DurationInterval

    - returns: DurationInterval
    */
    public init(startDuration: Duration, stopDuration: Duration) {
        self.startDuration = startDuration
        self.stopDuration = stopDuration
        self.duration = stopDuration - startDuration
    }
    
    /**
    Create a DurationInterval with the total Duration and a start Duration

    - parameter duration:      Total Duration of DurationInterval
    - parameter startDuration: Duration to start the DurationInterval

    - returns: DurationInterval
    */
    public init(duration: Duration, startDuration: Duration) {
        self.duration = duration
        self.startDuration = startDuration
        self.stopDuration = duration + startDuration
    }
    
    public init(startDuration: Duration) {
        self.duration = DurationZero
        self.startDuration = startDuration
        self.stopDuration = startDuration
    }
    
    public init?(_ string: String) {
        guard let durationInterval = DurationIntervalParser().parse(string)
            as? DurationInterval else { return nil }
        self = durationInterval
    }
    
    public mutating func trimStartDurationTo(duration: Duration) {
        self.startDuration = duration
    }
    
    public mutating func trimStopDurationTo(duration: Duration) {
        self.stopDuration = duration
    }
    
    /**
    If this DurationInterval contains Duration. Inclusive at start, exclusive at stop.

    - parameter duration: Duration to be check if contained within DurationInterval

    - returns: If this DurationInterval contains the Duration
    */
    public func contains(duration: Duration) -> Bool {
        return duration >= startDuration && duration < stopDuration
    }
    
    public func contains(durationInterval: DurationInterval) -> Bool {
        return (
            startDuration <= durationInterval.startDuration &&
            stopDuration >= durationInterval.stopDuration
        )
    }
    
    public func intersectsWith(durationNode: DurationNode) -> Bool {
        for leaf in durationNode.leaves as! [DurationNode] {
            if contains(leaf.durationInterval.startDuration) { return true }
        }
        return false
    }
    
    public func intersectsWith(durationInterval: DurationInterval) -> Bool {
        // implement .Intersection
        let relationship: IntervalRelationship = [
            .Equal, .Starts, .Finishes, .Overlaps, .During
        ]
        return relationship.contains(durationInterval.relationshipToDurationInterval(self))
    }
    
    public func bisectAtDuration(duration: Duration) -> (DurationInterval, DurationInterval)? {
        guard contains(duration) else { return nil }
        let first = DurationInterval(startDuration: startDuration, stopDuration: duration)
        let second = DurationInterval(startDuration: duration, stopDuration: stopDuration)
        return (first, second)
    }
    
    // TODO DOC COMMENT
    public func makeUnionWithDurationInterval(other: DurationInterval) -> DurationInterval {
        let start = [startDuration, other.startDuration].sort(<).first!
        let stop = [stopDuration, other.stopDuration].sort(>).first!
        return DurationInterval(startDuration: start, stopDuration: stop)
    }
    
    /**
    Get the relationship between the DurationInterval and another.

    - parameter other: Another DurationInterval

    - returns: DurationInterval
    */
    public func relationshipToDurationInterval(other: DurationInterval)
        -> IntervalRelationship
    {
        switch (other.startDuration, other.stopDuration) {
        case (startDuration, stopDuration):
            return .Equal
        case _ where startDuration == other.startDuration && stopDuration < other.stopDuration:
            return .Starts
        case _ where startDuration > other.startDuration && stopDuration == other.stopDuration:
            return .Finishes
        case _ where stopDuration == other.startDuration || startDuration == other.stopDuration:
            return .Meets
        case _ where startDuration < other.startDuration && other.contains(stopDuration):
            return .Overlaps
        case _ where stopDuration > other.stopDuration && other.contains(startDuration):
            return .Overlaps
        case _ where startDuration > other.startDuration && stopDuration < other.stopDuration:
            return .During
        case _ where startDuration < other.startDuration && stopDuration > other.stopDuration:
            return .During // ?
        case _ where startDuration < other.startDuration && stopDuration < other.startDuration:
            return .TakesPlaceBefore
        case _ where startDuration > other.stopDuration:
            return .TakesPlaceAfter
        default: return .TakesPlaceBefore
        }
    }
    
    private mutating func setDuration() {
        self.duration = stopDuration - startDuration
    }
    
    private mutating func setStopDuration() {
        self.stopDuration = startDuration + duration   
    }

    private func getDescription() -> String {
        return "(\(startDuration)) -> (\(stopDuration)): (\(duration))"
    }
}

public func == (lhs: DurationInterval, rhs: DurationInterval) -> Bool {
    return lhs.relationshipToDurationInterval(rhs) == .Equal
}

public func == (lhs: DurationInterval, string: String) -> Bool {
    guard let rhs = DurationInterval(string) else { return false } // should throw error
    return lhs == rhs
}

/// Identity DurationInterval
public let DurationIntervalZero = DurationInterval()

