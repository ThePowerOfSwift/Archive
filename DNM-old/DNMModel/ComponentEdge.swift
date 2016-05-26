//
//  ComponentEdge.swift
//  DNMModel
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class ComponentEdge: Component {
    
    public override var identifier: String { return "Edge" }
    
    // TODO: change to own type
    public override var type: ComponentType { return "pitches" }
    public override var representationType: ComponentRepresentationType { return .GraphBearing }
}