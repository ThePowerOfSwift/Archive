//
//  StaffModel.swift
//  Staff
//
//  Created by James Bean on 1/11/17.
//
//

import Collections
import Plot
import PitchSpellingTools

public struct StaffModel: PlotModel {
    
    public typealias Entity = SpelledPitch
    
    /// TODO: Handle multiple voices within single staff point
    /// - Either, multiple points
    /// - Or, a point handles multiple voices (or [Set<...>])
    var points: [Double: [StaffPointModel]] = [:]
    
    let clef: StaffClef
    
    public init(clef: StaffClef = StaffClef(.treble)) {
        self.clef = clef
    }
    
    public mutating func addPoint(_ point: StaffPointModel, at position: Double) {
        points.safelyAppend(point, toArrayWith: position)
    }
}
