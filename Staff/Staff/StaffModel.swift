//
//  StaffModel.swift
//  Staff
//
//  Created by James Bean on 1/11/17.
//
//

import Plot
import PitchSpellingTools

public struct StaffModel: PlotModel {
    
    public typealias Entity = SpelledPitch
    
    var points: [StaffPointModel] = []
    
    let clef: StaffClef
    
    public init(clef: StaffClef) {
        self.clef = clef
    }
    
    public mutating func addPoint(_ point: StaffPointModel) {
        points.append(point)
    }
}
