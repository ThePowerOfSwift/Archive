//
//  GraphID.swift
//  DNM_iOS
//
//  Created by James Bean on 1/1/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation
import DNMModel

public typealias GraphID = String

public struct GraphIdentifierPath {
    
    public let performerID: PerformerID
    public let instrumentID: InstrumentID
    public let graphID: GraphID
    
    public init(_ performerID: PerformerID, _ instrumentID: InstrumentID, _ graphID: GraphID) {
        self.performerID = performerID
        self.instrumentID = instrumentID
        self.graphID = graphID
    }
}