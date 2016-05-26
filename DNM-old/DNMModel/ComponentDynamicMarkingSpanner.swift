//
//  ComponentDynamicMarkingSpanner.swift
//  DNMModel
//
//  Created by James Bean on 12/26/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public class ComponentDynamicMarkingSpanner: Component {
    public override var type: ComponentType { return "dynamics" }
    public override var representationType: ComponentRepresentationType { return .SpannerFloating }
}

public class ComponentDynamicMarkingSpannerStart: ComponentDynamicMarkingSpanner {
    public override var identifier: String { return "DynamicMarkingSpannerStart" }
}

public class ComponentDynamicMarkingSpannerStop: ComponentDynamicMarkingSpanner {
    public override var identifier: String { return "DynamicMarkingSpannerStop" }
}