//
//  ComponentOrganizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/11/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class ComponentOrganizerTests: XCTestCase {

    func testComponentsByInstrumentIDByPerformerID() {
        let components: [Component] = [
            ComponentPitch(performerID: "ID", instrumentID: "id", values: [60]),
            ComponentArticulation(performerID: "ID", instrumentID: "id", values: [">"]),
            ComponentDynamicMarking(performerID: "ID", instrumentID: "id", value: "fff")
        ]
        
        let organizer = ComponentOrganizer(components: components)
        organizer.componentModel
        print("componentsByIIDByPID: \(organizer.componentModel)")
    }
    
    // TODO: implement
    private func makeSingleInstrumentIdentifierPathComponents() -> [Component] {
        return [
            ComponentPitch(performerID: "ID", instrumentID: "id", values: [60]),
            ComponentArticulation(performerID: "ID", instrumentID: "id", values: [">"]),
            ComponentDynamicMarking(performerID: "ID", instrumentID: "id", value: "fff")
        ]
    }
    
    // TODO: implement
    private func makeSinglePerformerIDComponents() {
        
    }
    
    // TODO: implement
    private func makeIdentifierHetergeneousComponents() {
        
    }
}
