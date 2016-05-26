//
//  ComponentTests.swift
//  DNMModel
//
//  Created by James Bean on 11/22/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class ComponentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testComponentRest() {
        let rest = ComponentRest(performerID: "p", instrumentID: "i")
        let identifierPath = InstrumentIdentifierPath("p", "i")
        XCTAssert(rest.instrumentIdentifierPath == identifierPath)
        XCTAssert(rest.representationType == .GraphBearing)
        XCTAssert(rest.type == "pitches")
        XCTAssert(rest.description == "Rest")
    }
    
    func testComponentPitch() {
        let pitch = ComponentPitch(performerID: "p", instrumentID: "i", values: [60])
        let identifierPath = InstrumentIdentifierPath("p", "i")
        XCTAssert(pitch.instrumentIdentifierPath == identifierPath)
        XCTAssert(pitch.values == [60])
        XCTAssert(pitch.representationType == .GraphBearing)
        XCTAssert(pitch.type == "pitches")
        XCTAssert(pitch.description == "Pitch: { 60.0 }")
    }
    
    func testComponentPitchAbbreviated() {
        let pitch = p(60)
        XCTAssert(pitch.values == [60])
    }
    
    func testComponentArticulation() {
        let art = ComponentArticulation(performerID: "p", instrumentID: "i", values: [">"])
        let identifierPath = InstrumentIdentifierPath("p", "i")
        XCTAssert(art.instrumentIdentifierPath == identifierPath)
        XCTAssert(art.values == [">"])
        XCTAssert(art.representationType == .GraphDecorating)
        XCTAssert(art.type == "articulations")
        XCTAssert(art.description == "Articulation: { > }")
    }
    
    func testComponentDynamicMarking() {
        let marking = ComponentDynamicMarking(performerID: "p", instrumentID: "i", value: "ff")
        let identifierPath = InstrumentIdentifierPath("p", "i")
        XCTAssert(marking.instrumentIdentifierPath == identifierPath)
        XCTAssert(marking.value == "ff")
        XCTAssert(marking.representationType == .SpannerFloating)
        XCTAssert(marking.type == "dynamics")
        XCTAssert(marking.description == "DynamicMarking: ff")
    }
    
    func testComponentDynamicMarkingSpannerStart() {
        let start = ComponentDynamicMarkingSpannerStart(performerID: "p", instrumentID: "i")
        let identifierPath = InstrumentIdentifierPath("p", "i")
        XCTAssert(start.instrumentIdentifierPath == identifierPath)
        XCTAssert(start.representationType == .SpannerFloating)
        XCTAssert(start.type == "dynamics")
        XCTAssert(start.description == "DynamicMarkingSpannerStart")
    }

    func testComponentDynamicMarkingSpannerStop() {
        let stop = ComponentDynamicMarkingSpannerStop(performerID: "p", instrumentID: "i")
        let identifierPath = InstrumentIdentifierPath("p", "i")
        XCTAssert(stop.instrumentIdentifierPath == identifierPath)
        XCTAssert(stop.representationType == .SpannerFloating)
        XCTAssert(stop.type == "dynamics")
        XCTAssert(stop.description == "DynamicMarkingSpannerStop")
    }
    
    func testComponentNode() {
        let node = ComponentNode(performerID: "p", instrumentID: "i")
        let identifierPath = InstrumentIdentifierPath("p", "i")
        XCTAssert(node.instrumentIdentifierPath == identifierPath)
        XCTAssert(node.type == "pitches")
        XCTAssert(node.representationType == .GraphBearing)
        XCTAssert(node.description == "Node")
    }
    
    func testComponentEdge() {
        let edge = ComponentEdge(performerID: "p", instrumentID: "i")
        let identifierPath = InstrumentIdentifierPath("p", "i")
        XCTAssert(edge.instrumentIdentifierPath == identifierPath)
        XCTAssert(edge.type == "pitches")
        XCTAssert(edge.representationType == .GraphBearing)
        XCTAssert(edge.description == "Edge")
    }
    
    func testComponentSlurStart() {
        let slurStart = ComponentSlurStart(performerID: "p", instrumentID: "i")
        let identifierPath = InstrumentIdentifierPath("p", "i")
        XCTAssert(slurStart.instrumentIdentifierPath == identifierPath)
        XCTAssert(slurStart.type == "slurs")
        XCTAssert(slurStart.representationType == .SpannerLigature)
        XCTAssert(slurStart.description == "SlurStart")
    }
    
    func testComponentSlurStop() {
        let slurStop = ComponentSlurStop(performerID: "p", instrumentID: "i")
        let identifierPath = InstrumentIdentifierPath("p", "i")
        XCTAssert(slurStop.instrumentIdentifierPath == identifierPath)
        XCTAssert(slurStop.type == "slurs")
        XCTAssert(slurStop.representationType == .SpannerLigature)
        XCTAssert(slurStop.description == "SlurStop")
    }
}
