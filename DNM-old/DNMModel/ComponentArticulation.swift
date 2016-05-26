//
//  ComponentArticulation.swift
//  DNMModel
//
//  Created by James Bean on 12/26/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public class ComponentArticulation: Component {
    
    // TODO: consider making this a single value, where there is a ComponentPitch for EACH val
    public let values: [String]
    
    public override var identifier: String { return "Articulation" }
    public override var type: ComponentType { return "articulations" }
    public override var representationType: ComponentRepresentationType { return .GraphDecorating }
    
    public init(
        performerID: PerformerID = "ID",
        instrumentID: InstrumentID = "id",
        values: [String]
    )
    {
        self.values = values
        super.init(performerID: performerID, instrumentID: instrumentID)
    }
    
    public init(_ value: String) {
        self.values = [value]
        super.init(performerID: "ID", instrumentID: "id")
    }
    
    public init(_ values: String...) {
        self.values = values
        super.init(performerID: "ID", instrumentID: "id")
    }
    
    internal override func getDescription() -> String {
        var result = identifier
        result += ": { "
        for (v, value) in values.enumerate() {
            if v > 0 { result += " , " }
            result += "\(value)"
        }
        result += " }"
        return result
    }
}

public typealias a = ComponentArticulation