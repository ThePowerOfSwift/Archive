//
//  Component.swift
//  DNMModel
//
//  Created by James Bean on 8/11/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

// TODO: Conform to Hashable
public class Component: CustomStringConvertible, Comparable {
    
    public var description: String { return getDescription() }
    
    public let instrumentIdentifierPath: InstrumentIdentifierPath
    public var identifier: String { return "Abstract" }
    public var type: ComponentType { return "abstract" }
    public var representationType: ComponentRepresentationType { return .GraphBearing }
    
    public init(performerID: PerformerID, instrumentID: InstrumentID) {
        self.instrumentIdentifierPath = InstrumentIdentifierPath(performerID, instrumentID)
    }
    
    internal func getDescription() -> String {
        return identifier
    }
}

public func == (lhs: Component, rhs: Component) -> Bool {
    return lhs.instrumentIdentifierPath == rhs.instrumentIdentifierPath
}

public func < (lhs: Component, rhs: Component) -> Bool {
    return lhs.representationType < rhs.representationType
}

public func <= (lhs: Component, rhs: Component) -> Bool {
    return lhs.representationType <= rhs.representationType
}

public func > (lhs: Component, rhs: Component) -> Bool {
    return lhs.representationType > rhs.representationType
}

public func >= (lhs: Component, rhs: Component) -> Bool {
    return lhs.representationType >= rhs.representationType
}