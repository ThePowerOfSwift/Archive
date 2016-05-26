//
//  ComponentDynamicMarking.swift
//  DNMModel
//
//  Created by James Bean on 12/26/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public class ComponentDynamicMarking: Component {
    
    public let value: String
    
    public override var identifier: String { return "DynamicMarking" }
    public override var type: ComponentType { return "dynamics" }
    public override var representationType: ComponentRepresentationType {
        return .SpannerFloating
    }
    
    public init(
        performerID: PerformerID = "ID",
        instrumentID: InstrumentID = "id",
        value: String
    )
    {
        self.value = value
        super.init(performerID: performerID, instrumentID: instrumentID)
    }
    
    public init(_ value: String) {
        self.value = value
        super.init(performerID: "ID", instrumentID: "id")
    }
    
    internal override func getDescription() -> String {
        return "\(identifier): \(value)"
    }
}

public typealias d = ComponentDynamicMarking