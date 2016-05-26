//
//  ComponentSlur.swift
//  DNMModel
//
//  Created by James Bean on 12/26/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public class ComponentSlur: Component {
    public override var type: ComponentType { return "slurs" }
    public override var representationType: ComponentRepresentationType { return .SpannerLigature }
}

public class ComponentSlurStart: ComponentSlur {
    public override var identifier: String { return "SlurStart" }
    
    public init() {
        super.init(performerID: "ID", instrumentID: "id")
    }
    
    public override init(performerID: PerformerID, instrumentID: InstrumentID) {
        super.init(performerID: performerID, instrumentID: instrumentID)
    }
}

public class ComponentSlurStop: ComponentSlur {
    public override var identifier: String { return "SlurStop" }
    
    public init() {
        super.init(performerID: "ID", instrumentID: "id")
    }
    
    public override init(performerID: PerformerID, instrumentID: InstrumentID) {
        super.init(performerID: performerID, instrumentID: instrumentID)
    }
}

