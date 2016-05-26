//
//  Performer.swift
//  DNMModel
//
//  Created by James Bean on 12/16/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public typealias PerformerID = String

public struct Performer: Equatable {
    
    public var identifier: String
    public var fullName: String
    public var abbreviatedName: String
    public var instrumentTypes: [InstrumentType] = []
    
    // TODO: implement, get into init()
    public var instrumentTypeByInstrumentID: [InstrumentID: InstrumentType] = [:]
    
    // perhaps this is better than above
    public var instruments: [Instrument] = []
    
    public init(
        identifier: String,
        fullName: String? = nil,
        abbreviatedName: String? = nil,
        instrumentTypes: [InstrumentType] = []
    )
    {
        self.identifier = identifier
        self.instrumentTypes = instrumentTypes
        self.fullName = fullName ?? identifier
        self.abbreviatedName = abbreviatedName ?? identifier
    }
}

extension Performer: CustomStringConvertible {
    
    // todo: update
    public var description: String {
        return "Performer"
    }
}

public func ==(lhs: Performer, rhs: Performer) -> Bool {
    return false
}