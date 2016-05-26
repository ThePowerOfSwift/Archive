//
//  TempoMarking_model.swift
//  DNMModel
//
//  Created by James Bean on 10/7/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

/**
Structure indicating the establishment of a Tempo
*/
public struct TempoMarking: DurationSpanning {
    
    // TODO: change to Floats (and later: Tempo(Function))
    /// The beats-per-minute value of the Tempo being established
    public var value: Int
    
    /// The SubdivisionValue to which this Tempo is applied
    public var subdivisionValue: Int
    
    /// The Duration that this TempoMarking is offset from the beginning of the piece
    public var offsetDuration: Duration
    
    public var durationInterval: DurationInterval {
        return DurationInterval(duration: DurationZero, startDuration: offsetDuration)
    }
    
    /**
    Create a TempoMarking with the beats-per-minute value,
    the subdivisionLevel (1 = 1/8th-note, 2 = 1/16th-note, etc),
    and the offsetDuration.
    
    - parameter value:            Beats-per-minute value
    - parameter subdivisionLevel: SubdivisionLevel (1 = 1/8th-note, 2 = 1/16th-note, etc)
    - parameter offsetDuration:   Duration offset from the beginning of the piece
    
    - returns: TempoMarking
    */
    public init(value: Int, subdivisionValue: Int, offsetDuration: Duration) {
        self.value = value
        self.subdivisionValue = subdivisionValue
        self.offsetDuration = offsetDuration
    }
    
    public init?(string: String) {
        // "48: 8 @ 5,8"; "94: 16 from 21,32 -> 49,64 * (1/4)"
        return nil
    }
}