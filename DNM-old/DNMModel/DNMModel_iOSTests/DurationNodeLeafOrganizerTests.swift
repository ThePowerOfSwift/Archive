//
//  DurationNodeLeafOrganizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationNodeLeafOrganizerTests: XCTestCase {

    func testLeavesByInstrumentIDByPerformerID() {
        
        // create first leaf, add components
        let leaf0 = DurationNode.with(Duration(1,16))
        leaf0.components = [
            ComponentPitch(performerID: "ID0", instrumentID: "id0", values: [60])
        ]
        
        // create second leaf, add components
        let leaf1 = DurationNode.with(Duration(1,16))
        leaf1.components = [
            ComponentPitch(performerID: "ID1", instrumentID: "id1", values: [62])
        ]
        
        // organize leaves
        let organizer = DurationNodeLeafOrganizer(leaves: [leaf0, leaf1])
        let leavesOrganized = organizer.leavesByInstrumentIDByPerformerID
        
        XCTAssert(leavesOrganized["ID0"] != nil)
        XCTAssert(leavesOrganized["ID1"] != nil)
        XCTAssert(leavesOrganized["ID0"]!["id0"] != nil)
        XCTAssert(leavesOrganized["ID1"]!["id1"] != nil)
    }
    
    func testFilterLeavesWithComponentFilters() {
        
        let leaf0 = DurationNode.with(Duration(1,16))
        leaf0.components = [
            ComponentPitch(performerID: "ID0", instrumentID: "id0", values: [60])
        ]
        
        // create second leaf, add components
        let leaf1 = DurationNode.with(Duration(1,16))
        leaf1.components = [
            ComponentPitch(performerID: "ID1", instrumentID: "id1", values: [62])
        ]
        let organizer = DurationNodeLeafOrganizer(leaves: [leaf0, leaf1])
        let leavesOrganized = organizer.leavesByInstrumentIDByPerformerID
        
        let componentFilter = ComponentFilter(
            durationInterval: DurationInterval(
                startDuration: DurationZero, stopDuration: DurationZero
            )
        )
        componentFilter.componentTypesShownByPerformerID
        
    }
}
