//
//  InstrumentIdentifierPath.swift
//  DNMModel
//
//  Created by James Bean on 1/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class InstrumentIdentifierPath: KeyPath {
    
    public let performerID: PerformerID
    public let instrumentID: InstrumentID
    
    public init(_ performerID: PerformerID, _ instrumentID: InstrumentID) {
        self.performerID = performerID
        self.instrumentID = instrumentID
        super.init(performerID, instrumentID)
    }
}

public func == (lhs: InstrumentIdentifierPath, rhs: InstrumentIdentifierPath) -> Bool {
    return lhs.performerID == rhs.performerID && lhs.instrumentID == rhs.instrumentID
}