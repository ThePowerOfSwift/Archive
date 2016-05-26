//
//  ComponentPitch.swift
//  DNMModel
//
//  Created by James Bean on 12/26/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public class ComponentPitch: Component {
    
    // TODO: consider making this a single value, where there is a ComponentPitch for EACH val
    public let values: [Float]

    public override var identifier: String { return "Pitch" }
    public override var type: ComponentType { return "pitches" }
    public override var representationType: ComponentRepresentationType { return .GraphBearing }
    
    public init(
        performerID: PerformerID = "ID",
        instrumentID: InstrumentID = "id",
        values: [Float]
    )
    {
        self.values = values
        super.init(performerID: performerID, instrumentID: instrumentID)
    }
    
    public init(_ value: Float) {
        self.values = [value]
        super.init(performerID: "ID", instrumentID: "id")
    }
    
    public init(_ values: Float...) {
        self.values = values
        super.init(performerID: "ID", instrumentID: "id")
    }
    
    internal override func getDescription() -> String {
        var result = identifier
        result += ": { "
        for (v, value) in values.enumerate() {
            if v > 0 { result += ", " }
            result += "\(value)"
        }
        result += " }"
        return result
    }
}

public typealias p = ComponentPitch