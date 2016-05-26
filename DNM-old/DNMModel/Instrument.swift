//
//  Instrument.swift
//  DNMModel
//
//  Created by James Bean on 12/18/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public typealias InstrumentID = String

public struct Instrument {
    
    public let identifierPath: InstrumentIdentifierPath
    public let type: InstrumentType
    
    public init(identifierPath: InstrumentIdentifierPath, type: InstrumentType) {
        self.identifierPath = identifierPath
        self.type = type
    }
}

extension Instrument: CustomStringConvertible {
    
    public var description: String { return "\(type): \(identifierPath)" }
}