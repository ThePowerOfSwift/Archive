//
//  ComponentRest.swift
//  DNMModel
//
//  Created by James Bean on 12/26/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public class ComponentRest: Component {
    
    public override var identifier: String { return "Rest" }
    
    // TODO: distance rest from "pitches"
    public override var type: ComponentType { return "pitches" }
    public override var representationType: ComponentRepresentationType { return .GraphBearing }
    
    public override init(performerID: PerformerID, instrumentID: InstrumentID) {
        super.init(performerID: performerID, instrumentID: instrumentID)
    }
    
    public init() {
        super.init(performerID: "ID", instrumentID: "id")
    }
}

public typealias r = ComponentRest