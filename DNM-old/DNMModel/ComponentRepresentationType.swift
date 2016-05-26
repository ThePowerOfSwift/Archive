//
//  ComponentRepresentationType.swift
//  DNMModel
//
//  Created by James Bean on 1/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public struct ComponentRepresentationType: OptionSetType, Comparable {
    
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    public static var None = ComponentRepresentationType(rawValue: 1)
    
    // TODO: find better name: GraphOriginating, GraphInfo, etc
    /// Pitches, Node, Edge
    public static var GraphBearing = ComponentRepresentationType(rawValue: 2)
    
    // TODO: find better name: GraphInfoOrbiting
    // Articulations
    public static var GraphDecorating = ComponentRepresentationType(rawValue: 4)
    
    /// Stem Articulations (tremolo, air transitions, etc)
    public static var SpannerStem = ComponentRepresentationType(rawValue: 8)
    
    /// Spanner connecting two GraphEvents
    public static var SpannerLigature = ComponentRepresentationType(rawValue: 16)
    
    /// DynamicMarking(Spanner)s, Labels
    public static var SpannerFloating = ComponentRepresentationType(rawValue: 32)
}

public func == (lhs: ComponentRepresentationType, rhs: ComponentRepresentationType) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

public func < (lhs: ComponentRepresentationType, rhs: ComponentRepresentationType) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

public func <= (lhs: ComponentRepresentationType, rhs: ComponentRepresentationType) -> Bool {
    return lhs.rawValue <= rhs.rawValue
}

public func > (lhs: ComponentRepresentationType, rhs: ComponentRepresentationType) -> Bool {
    return lhs.rawValue > rhs.rawValue
}
    
public func >= (lhs: ComponentRepresentationType, rhs: ComponentRepresentationType) -> Bool {
    return lhs.rawValue >= rhs.rawValue
}