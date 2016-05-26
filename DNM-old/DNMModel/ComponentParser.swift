//
//  ComponentParser.swift
//  DNMModel
//
//  Created by James Bean on 1/25/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

internal class ComponentParser {

    internal enum Error: ErrorType { case Error }
    
    private var components: [Component] = []
    private let performerID: PerformerID
    private let instrumentID: InstrumentID
    
    internal init(performerID: PerformerID, instrumentID: InstrumentID) {
        self.performerID = performerID
        self.instrumentID = instrumentID
    }
    
    internal func parse(tokenContainer: TokenContainer) throws -> [Component] {
        for token in tokenContainer.tokens[1..<tokenContainer.tokens.count] {
            try parse(token)
        }
        return components
    }
    
    private func parse(token: Token) throws {
        switch token.identifier {
        case "Label":
            try label(token)
        case "Node":
            addComponent(ComponentNode(performerID: performerID, instrumentID: instrumentID))
        case "Edge":
            addComponent(ComponentEdge(performerID: performerID, instrumentID: instrumentID))
        case "Pitch":
            try pitch(token)
        case "Articulation":
            try articulation(token)
        case "DynamicMarking":
            try dynamicMarking(token)
        case "SlurStart":
            addComponent(ComponentSlurStart(performerID: performerID, instrumentID: instrumentID))
        case "SlurStop":
            addComponent(ComponentSlurStop(performerID: performerID, instrumentID: instrumentID))
        case "ExtensionStop":
            addComponent(ComponentExtensionStop())
        default:
            break
        }
    }
    
    private func label(token: Token) throws {
        guard let labelContainer = token as? TokenContainer else { throw Error.Error }
        guard let textToken = labelContainer.tokens.first as? TokenString else {
            throw Error.Error
        }
        let component = ComponentLabel(
            performerID: performerID, instrumentID: instrumentID, value: textToken.value
        )
        print("add label component: \(component)")
        addComponent(component)
    }
    
    private func pitch(token: Token) throws {
        guard let pitchContainer = token as? TokenContainer else { throw Error.Error }
        var values: [Float] = []
        for token in pitchContainer.tokens {
            guard let tokenFloat = token as? TokenFloat else { continue }
            values.append(tokenFloat.value)
        }
        guard values.count > 0 else { throw Error.Error }
        let componentPitch = ComponentPitch(
            performerID: performerID, instrumentID: instrumentID, values: values
        )
        addComponent(componentPitch)
    }
    
    private func articulation(token: Token) throws {
        guard let articulationContainer = token as? TokenContainer else { throw Error.Error }
        var values: [String] = []
        for token in articulationContainer.tokens {
            guard let tokenString = token as? TokenString else { continue }
            values.append(tokenString.value)
        }
        guard values.count > 0 else { throw Error.Error }
        let componentArticulation = ComponentArticulation(
            performerID: performerID, instrumentID: instrumentID, values: values
        )
        addComponent(componentArticulation)
    }
    
    private func dynamicMarking(token: Token) throws {
        guard let dynamicMarkingContainer = token as? TokenContainer else { throw Error.Error }

        guard let markingToken = dynamicMarkingContainer.tokens.first as? TokenString else {
            throw Error.Error
        }
        let component = ComponentDynamicMarking(
            performerID: performerID, instrumentID: instrumentID, value: markingToken.value
        )
        addComponent(component)
        
        // TODO: refactor
        if dynamicMarkingContainer.tokens.count > 1 {
            for spannerToken in dynamicMarkingContainer.tokens[1..<dynamicMarkingContainer.tokens.count] {
                switch spannerToken.identifier {
                case "SpannerStart":
                    let component = ComponentDynamicMarkingSpannerStart(
                        performerID: performerID, instrumentID: instrumentID
                    )
                    addComponent(component)
                case "SpannerStop":
                    let component = ComponentDynamicMarkingSpannerStop(
                        performerID: performerID, instrumentID: instrumentID
                    )
                    addComponent(component)
                default:
                    break
                }
            }
        }
    }
    
    private func addComponent(component: Component) {
        components.append(component)
    }
}