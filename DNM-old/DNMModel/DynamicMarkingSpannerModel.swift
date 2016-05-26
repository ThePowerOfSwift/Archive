//
//  DynamicMarkingSpannerModel.swift
//  DNMModel
//
//  Created by James Bean on 12/28/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public struct DynamicMarkingSpannerModel: DynamicMarkingElementModel, Equatable {
    
    public let direction: DynamicMarkingSpannerDirection
    public let durationInterval: DurationInterval
    
    public init(direction: DynamicMarkingSpannerDirection, durationInterval: DurationInterval) {
        self.direction = direction
        self.durationInterval = durationInterval
    }
}

extension DynamicMarkingSpannerModel: CustomStringConvertible {
    
    public var description: String {
        switch direction {
        case .Crescendo: return "<"
        case .Decrescendo: return ">"
        case .Static: return "--"
        }
    }
}

public func == (lhs: DynamicMarkingSpannerModel, rhs: DynamicMarkingSpannerModel) -> Bool {
    return lhs.direction == rhs.direction && lhs.durationInterval == rhs.durationInterval
}