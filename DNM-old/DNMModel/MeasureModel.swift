//
//  MeasureModel.swift
//  DNMModel
//
//  Created by James Bean on 8/15/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
Musical MeasureModel
*/
public struct MeasureModel: DurationSpanning, Equatable {
  
    // 1-based count of numbers (index + 1)
    public var number: Int = 0
    
    /// Duration of MeasureModel
    public var duration: Duration = DurationZero
    
    /// Offset Duration of MeasureModel (in current implementation: from the beginning of the piece)
    public var offsetDuration: Duration = DurationZero
    
    public var durationInterval: DurationInterval {
        return DurationInterval(duration: duration, startDuration: offsetDuration)
    }

    /**
    When graphically represented, 
    should the Duration of this MeasureModel be shown with a TimeSignature
    */
    public var hasTimeSignature: Bool = true

    // TODO: Test this
    public static func rangeFromMeasures(
        measures: [MeasureModel],
        startingAtIndex index: Int,
        constrainedByDuration maximumDuration: Duration
    ) -> [MeasureModel]?
    {
        var measureRange: [MeasureModel] = []
        var m: Int = index
        var accumDur: Duration = DurationZero
        while m < measures.count && accumDur < maximumDuration {
            if accumDur + measures[m].duration <= maximumDuration {
                measureRange.append(measures[m])
                accumDur += measures[m].duration
                m++
            }
            else { break }
        }
        if measureRange.count == 0 { return nil }
        return measureRange
    }
    
    /**
    Create a MeasureModel with an Duration offset from the beginning of the piece
    
    - parameter offsetDuration: Duration offset from the beginning of the piece
    
    - returns: MeasureModel
    */
    public init(duration: Duration = DurationZero, offsetDuration: Duration = DurationZero) {
        self.duration = duration
        self.offsetDuration = offsetDuration
    }
    
    public init(durationInterval: DurationInterval) {
        self.duration = durationInterval.duration
        self.offsetDuration = durationInterval.startDuration
    }
    
    /**
    Set if when graphically represented,
    should the Duration of this MeasureModel be shown with a TimeSignature
    
    - parameter hasTimeSignature: If a TimeSignature should be shown in the score.
    */
    public mutating func setHasTimeSignature(hasTimeSignature: Bool) {
        self.hasTimeSignature = hasTimeSignature
    }
}

extension MeasureModel: CustomStringConvertible {

    public var description: String {
        return "m. \(number): \(durationInterval)"
    }
}

public func == (lhs: MeasureModel, rhs: MeasureModel) -> Bool {
    return lhs.durationInterval == rhs.durationInterval
}