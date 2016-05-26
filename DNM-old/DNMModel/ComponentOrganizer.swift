//
//  ComponentOrganizer.swift
//  DNMModel
//
//  Created by James Bean on 1/11/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public typealias ComponentModel = [PerformerID: [InstrumentID: [Component]]]

public class ComponentOrganizer {
    
    public var componentModel: ComponentModel { return getComponentModel() }
    
    private let components: [Component]
    
    public init(components: [Component]) {
        self.components = components
    }

    // TODO: add tests
    private func getComponentModel() -> ComponentModel {
        var result: ComponentModel = [:]
        components.forEach {
            result.safelyAppend($0, toArrayWithKeyPath: $0.instrumentIdentifierPath)
        }
        return result
    }
}