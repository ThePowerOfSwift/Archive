//
//  PerformerDeclaration.swift
//  DNMModel
//
//  Created by James Bean on 1/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public struct PerformerDeclaration {
    
    public let performerID: PerformerID
    public var instrumentTypeByID = OrderedDictionary<InstrumentID, InstrumentType>()
    
    public init(performerID: PerformerID) {
        self.performerID = performerID
    }
    
    public mutating func updateType(instrumentType: InstrumentType,
        forInstrumentID instrumentID: InstrumentID
    )
    {
        instrumentTypeByID[instrumentID] = instrumentType
    }
}