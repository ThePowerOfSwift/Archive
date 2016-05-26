//
//  Viewer.swift
//  DNM_iOS
//
//  Created by James Bean on 12/15/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation
import DNMModel

public struct Viewer: Equatable {
    
    public var identifier: PerformerID
    public var type: ViewerType
    public var instrumentTypes: [InstrumentType] = []
    
    public init(
        identifier: PerformerID, type: ViewerType, instrumentTypes: [InstrumentType] = []
    )
    {
        self.identifier = identifier
        self.type = type
        self.instrumentTypes = instrumentTypes
    }
}

public let ViewerOmni = Viewer(identifier: "omni", type: .Omni)

extension Viewer: CustomStringConvertible {
    
    public var description: String {
        return "Viewer: \(identifier); type: \(type); instrumentTypes: \(instrumentTypes)"
    }
}

public func ==(lhs: Viewer, rhs: Viewer) -> Bool {
    let identifiersAreEqual = lhs.identifier == rhs.identifier
    let typesAreEqual = lhs.type == rhs.type
    let instrumentTypesAreEqual = lhs.instrumentTypes == rhs.instrumentTypes
    return identifiersAreEqual && typesAreEqual && instrumentTypesAreEqual
}