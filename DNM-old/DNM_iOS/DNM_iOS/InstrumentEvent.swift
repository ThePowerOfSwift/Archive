//
//  InstrumentEvent.swift
//  DNM_iOS
//
//  Created by James Bean on 10/15/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

/**
Abstract generator and container of concrete GraphEvents
*/
public class InstrumentEvent: CustomStringConvertible {

    public var description: String { return getDescription() }
    
    internal let instrument: Instrument
    
    internal var leaf: DurationNode
    internal let x: CGFloat
    internal let width: CGFloat
    internal let stemDirection: StemDirection
    internal let scale: Scale
    
    public var graphEvents: [GraphEvent] = []
    
    public var hasGraphBearingComponents: Bool { return graphBearingComponents.count > 0 }
    
    private var components: [Component] { return leaf.components.sort(<) }
    private var graphBearingComponents: [Component] { return getGraphBearingComponents() }
    private var graphDecoratingComponents: [Component] { return getGraphDecoratingComponents() }
    
    public class func with(instrument: Instrument,
        leaf: DurationNode,
        x: CGFloat, 
        width: CGFloat, 
        stemDirection: StemDirection,
        scale: Scale
    ) -> InstrumentEvent
    {
        let classType = leaf.isRest ? InstrumentEventRest.self : subClassTypeFor(instrument)
        return classType.init(
            instrument: instrument,
            leaf: leaf, 
            x: x,
            width: width, 
            stemDirection: stemDirection,
            scale: scale
        )
    }
    
    private static func subClassTypeFor(instrument: Instrument) -> InstrumentEvent.Type {
        if Strings.containsInstrumentType(instrument.type) {
            return InstrumentEventString.self
        }
        return InstrumentEvent.self
    }
    
    public required init(
        instrument: Instrument,
        leaf: DurationNode,
        x: CGFloat,
        width: CGFloat,
        stemDirection: StemDirection,
        scale: Scale
    )
    {
        self.instrument = instrument
        self.leaf = leaf
        self.x = x
        self.width = width
        self.stemDirection = stemDirection
        self.scale = scale
    }
    
    public func filterOutAllComponentTypesBut(componentTypes: [ComponentType]) {
        leaf = leaf.copy()
        leaf.components = leaf.components.filter { componentTypes.contains($0.type) }
    }
    
    public func prepareGraphEvents() {
        graphEvents = makeGraphEvents()
    }
    
    internal func makeGraphEvents() -> [GraphEvent] {
        let graphEvents = graphBearingComponents.flatMap { makeGraphEventfor($0) }
        decorateGraphEvents(graphEvents)
        return graphEvents
    }
    
    internal func makeGraphEventfor(component: Component) -> GraphEvent? {
        guard canRenderComponent(component) else { return nil }
        let type = graphEventTypeFor(component)!
        let identifier = identifierFor(component)!
        let graphEvent = GraphEvent.with(type,
            identifier: identifier,
            leaf: leaf,
            x: x,
            width: width,
            stemDirection: stemDirection,
            scale: scale
        )
        graphEvent.instrumentEvent = self
        graphEvent.addComponent(component)
        return graphEvent
    }
    
    internal func canRenderComponent(component: Component) -> Bool {
        return identifierFor(component) != nil && graphEventTypeFor(component) != nil
    }
    
    internal func graphEventTypeFor(component: Component) -> GraphEventType? {
        switch component {
        case is ComponentNode: return .Node
        case is ComponentEdge: return .Edge
        case is ComponentPitch: return .Staff
        default: return nil
        }
    }
    
    internal func identifierFor(component: Component) -> GraphID? {
        switch component {
        case is ComponentRest: return "rest"
        case is ComponentNode: return "graph"
        case is ComponentEdge: return "graph"
        case is ComponentPitch: return "staff"
        default: return nil
        }
    }
    
    // refactor
    private func decorateGraphEvents(graphEvents: [GraphEvent]) {
        for graphEvent in graphEvents {
            for component in graphDecoratingComponents {
                switch component {
                case let articulation as ComponentArticulation:
                    for value in articulation.values {
                        if let type = ArticulationTypeWithMarking(value) {
                            graphEvent.addArticulationWithType(type)
                        }
                    }
                default: break
                }
            }
        }
    }
    
    public func stemEndYIn(context: CALayer) -> CGFloat {
        switch stemDirection {
        case .Down: return maxInfoYIn(context)
        case .Up: return minInfoYIn(context)
        }
    }
    
    public func minInfoYIn(context: CALayer) -> CGFloat {
        if graphEvents.count == 0 { return 0 }
        return graphEvents.map { context.convertY($0.minInfoY, fromLayer: $0) }.minElement()!
    }

    public func maxInfoYIn(context: CALayer) -> CGFloat {
        if graphEvents.count == 0 { return 0 }
        return graphEvents.map { context.convertY($0.maxInfoY, fromLayer: $0) }.maxElement()!
    }
    
    private func getGraphBearingComponents() -> [Component] {
        return components.filter { $0.representationType == .GraphBearing }
    }
    
    private func getGraphDecoratingComponents() -> [Component] {
        return components.filter { $0.representationType == .GraphDecorating }
    }
    
    internal func getDescription() -> String {
        return "\(instrument): x: \(x); stemDirection: \(stemDirection); \(leaf)"
    }
}