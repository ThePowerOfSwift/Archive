//
//  ArticulationType.swift
//  DNMModel
//
//  Created by James Bean on 1/18/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public func ArticulationTypeWithMarking(marking: String) -> ArticulationType? {
    switch marking {
    case ".": return ArticulationType.Staccato
    case ">": return ArticulationType.Accent
    case "-": return ArticulationType.Tenuto
    case "trem": return ArticulationType.Tremolo
    default: return nil
    }
}

public enum ArticulationType {
    case Accent, Staccato, Tenuto, Tremolo
    
    public static func random() -> ArticulationType {
        let types: [ArticulationType] = [.Accent, .Staccato, .Tenuto, .Tremolo]
        return types.random()
    }
}