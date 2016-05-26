//
//  StringInstrumentModel.swift
//  DNMModel
//
//  Created by James Bean on 1/8/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public struct StringInstrumentModel {
    
    private let strings: [StringModel]
    
    public init(stringMIDIValues: [Float]) {
        self.strings = stringMIDIValues.map {
            StringModel(fundamentalPitch: Pitch(midi: MIDI($0)))
        }
    }
}