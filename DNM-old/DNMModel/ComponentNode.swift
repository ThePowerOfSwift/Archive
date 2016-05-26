//
//  ComponentNode.swift
//  DNMModel
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class ComponentNode: Component {
    
    public override var identifier: String { return "Node" }
    
    // TODO: change to own type
    public override var type: ComponentType { return "pitches" }
    public override var representationType: ComponentRepresentationType { return .GraphBearing }
}