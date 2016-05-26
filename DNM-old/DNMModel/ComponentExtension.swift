//
//  ComponentExtension.swift
//  DNMModel
//
//  Created by James Bean on 12/26/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public class ComponentExtension: Component {
    public override var type: ComponentType { return "rhythm" }
    
    public init() {
        super.init(performerID: "", instrumentID: "")
    }
}

public class ComponentExtensionStart: ComponentExtension {
    public override var identifier: String { return "ExtensionStart" }
}

public class ComponentExtensionStop: ComponentExtension {
    public override var identifier: String { return "ExtensionStop" }
}