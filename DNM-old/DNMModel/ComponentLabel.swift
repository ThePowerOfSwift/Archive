//
//  ComponentLabel.swift
//  DNMModel
//
//  Created by James Bean on 1/29/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class ComponentLabel: Component {
    
    public let value: String
    
    public override var identifier: String { return "Label" }
    public override var type: ComponentType { return "articulations" }
    public override var representationType: ComponentRepresentationType {
        return .SpannerFloating
    }
    
    public init(performerID: PerformerID, instrumentID: InstrumentID, value: String) {
        self.value = value
        super.init(performerID: performerID, instrumentID: instrumentID)
    }
    
    internal override func getDescription() -> String {
        return "\(identifier): \(value)"
    }
}