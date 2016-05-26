 //
//  ScoreModelTests.swift
//  DNMModel
//
//  Created by James Bean on 11/23/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class ScoreModelTests: XCTestCase {
    
    func testInitWithString() {
        do {
            let scoreModel = try ScoreModel(string: "# 1,8\n| 1,8 VN vn\n\t1 p 60")
            XCTAssert(scoreModel.measures.count == 1)
            XCTAssert(scoreModel.durationNodes.count == 1)
        } catch {
            XCTFail()
        }
    }
    
    func testLabelStratumModels() {
        var scoreModel = ScoreModel()
        let durationNode = DurationNode.with(3,16)
        durationNode.addComponent(
            ComponentLabel(performerID: "VN", instrumentID: "vn", value: "pizz")
        )
        scoreModel.addDurationNode(durationNode)
        scoreModel.updateLabelStrata()
        XCTAssertEqual(scoreModel.labelStratumModels.count, 1)
    }
    
    func testAddMeasureTuple() {
        var scoreModel = ScoreModel()
        scoreModel.addMeasureWith((4,16))
        if let measure = scoreModel.measures.first {
            XCTAssert(measure.durationInterval.duration == Duration(4,16))
        } else {
            XCTFail()
        }
    }
    
    func testAddMeasureDurationSingle() {
        var scoreModel = ScoreModel()
        scoreModel.addMeasureWith(Duration(2,8))
        if let measure = scoreModel.measures.first {
            XCTAssert(measure.durationInterval.duration == Duration(2,8))
        } else {
            XCTFail()
        }
    }
    
    func testAddMeasureDurationMultipleForOffsetDuration() {
        var scoreModel = ScoreModel()
        scoreModel.addMeasureWith(Duration(2,8))
        scoreModel.addMeasureWith(Duration(3,8))
        if let secondMeasure = scoreModel.measures.second {
            XCTAssert(secondMeasure.durationInterval.startDuration == Duration(2,8))
        } else {
            XCTFail()
        }
    }
    
    func testAddMeasuresWithSubivisionValueAndBeatsArray() {
        var scoreModel = ScoreModel()
        scoreModel.addMeasuresWith(8, [1,2,3])
        XCTAssert(scoreModel.measures.count == 3)
        scoreModel.measures.forEach {
            XCTAssert($0.durationInterval.duration.subdivision!.value == 8)
        }
    }
    
    func testAddMeasuresOperator() {
        var scoreModel = ScoreModel()
        scoreModel += (8, [1,2,3])
        XCTAssert(scoreModel.measures.count == 3)
    }

    func testAddMeasuresTuples() {
        var scoreModel = ScoreModel()
        scoreModel.addMeasures([(1,8), (3,16), (42,64)])
        XCTAssert(scoreModel.measures.count == 3)
    }
    
    func testAddTempoMarking() {
        var scoreModel = ScoreModel()
        let tempoMarking = TempoMarking(
            value: 90, subdivisionValue: 8, offsetDuration: DurationZero
        )
        scoreModel.addTempoMarking(tempoMarking)
        XCTAssert(scoreModel.tempoMarkings.count == 1)
    }
    
    func testAddTempoMarkingWithValues() {
        var scoreModel = ScoreModel()
        scoreModel.addTempoMarking(48, 16, (35,32))
        XCTAssert(scoreModel.tempoMarkings.count == 1)
    }
    
    func testAddTempoMarkingOperator() {
        var scoreModel = ScoreModel()
        let tempoMarking = TempoMarking(
            value: 90, subdivisionValue: 8, offsetDuration: DurationZero
        )
        scoreModel += tempoMarking
        XCTAssert(scoreModel.tempoMarkings.count == 1)
    }
    
    func testAddTempoMarkingValuesOperator() {
        var scoreModel = ScoreModel()
        scoreModel += (48, 8, (491,64))
        XCTAssert(scoreModel.tempoMarkings.count == 1)
    }
    
    func testAddTempoMarkingsValuesOperator() {
        var scoreModel = ScoreModel()
        scoreModel += [(48, 8, (0,8)), (52, 8, (29,16)), (65, 16, (425,64))]
        XCTAssert(scoreModel.tempoMarkings.count == 3)
    }
    
    func testDurationInterval() {
        var scoreModel = ScoreModel()
        
        let measures = [
            MeasureModel(duration: Duration(2,16), offsetDuration: DurationZero),
            MeasureModel(duration: Duration(2,16), offsetDuration: Duration(2,16)),
            MeasureModel(duration: Duration(2,16), offsetDuration: Duration(4,16)),
            MeasureModel(duration: Duration(2,16), offsetDuration: Duration(6,16)),
            MeasureModel(duration: Duration(2,16), offsetDuration: Duration(8,16)),
            MeasureModel(duration: Duration(2,16), offsetDuration: Duration(10,16)),
            MeasureModel(duration: Duration(2,16), offsetDuration: Duration(12,16))
        ]
        
        scoreModel.measures = measures
        XCTAssert(scoreModel.durationInterval == DurationInterval(startDuration: DurationZero, stopDuration: Duration(14,16)))
    }

    func testComponentTypesByPerformerID() {
        var scoreModel = ScoreModel()
        
        let dn0 = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        dn0.addComponent(ComponentPitch(performerID: "VN", instrumentID: "vn", values: [60]))
        
        let dn1 = DurationNodeIntervalEnforcing(duration: Duration(3,16))
        dn1.addComponent(
            ComponentDynamicMarking(performerID: "VC", instrumentID: "vc", value: "fff")
        )
        
        scoreModel.durationNodes = [dn0, dn1]
        
        XCTAssert(
            scoreModel.componentTypesByPerformerID == [
                "VN": ["rhythm", "performer", "pitches"],
                "VC": ["rhythm", "performer", "dynamics"]
            ]
        )
    }
    
    func testLeaves() {
        
        let leaf0 = DurationNodeIntervalEnforcing(duration: Duration(3,16))
        let leaf1 = DurationNodeIntervalEnforcing(duration: Duration(2,16), offsetDuration: Duration(3,16), sequence: [])
        let leaf2 = DurationNodeIntervalEnforcing(duration: Duration(4,16), offsetDuration: Duration(5,16), sequence: [])
        
        var scoreModel = ScoreModel()
        scoreModel.durationNodes = [leaf0, leaf1, leaf2]
        XCTAssert(scoreModel.leaves == [leaf0, leaf1, leaf2])
    }
    
    func testMeasureContainingDuration() {
        let m0 = MeasureModel(duration: Duration(3,16), offsetDuration: DurationZero)
        let m1 = MeasureModel(duration: Duration(2,16), offsetDuration: Duration(3,16))
        let m2 = MeasureModel(duration: Duration(5,16), offsetDuration: Duration(5,16))
        
        var scoreModel = ScoreModel()
        scoreModel.measures = [m0, m1, m2]
        
        XCTAssert(scoreModel.measureContaining(Duration(24,8)) == nil)
        XCTAssert(scoreModel.measureContaining(DurationZero) != nil)
        XCTAssert(scoreModel.measureContaining(DurationZero)! == m0)
        XCTAssert(scoreModel.measureContaining(Duration(1,16))! == m0)
        XCTAssert(scoreModel.measureContaining(Duration(3,16))! == m1)
        XCTAssert(scoreModel.measureContaining(Duration(6,16))! == m2)
    }
    
    func testDynamicMarkingStrata() {
        var scoreModel = ScoreModel()
        let parent = DurationNodeIntervalEnforcing(duration: Duration(3,8))
        
        let child1 = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        child1.addComponent(
            ComponentDynamicMarking(performerID: "ID", instrumentID: "ID", value: "fff")
        )
        child1.addComponent(
            ComponentDynamicMarkingSpannerStart(performerID: "ID", instrumentID: "ID")
        )
        
        let child2 = DurationNodeIntervalEnforcing(duration: Duration(1,8), offsetDuration: Duration(1,8))
        child2.addComponent(
            ComponentDynamicMarking(performerID: "ID", instrumentID: "ID", value: "ppp")
        )
        child2.addComponent(
            ComponentDynamicMarkingSpannerStart(performerID: "ID", instrumentID: "ID")
        )
        child2.addComponent(
            ComponentDynamicMarkingSpannerStop(performerID: "ID", instrumentID: "ID")
        )
        
        let child3 = DurationNodeIntervalEnforcing(duration: Duration(1,8), offsetDuration: Duration(2,8))
        child3.addComponent(
            ComponentDynamicMarking(performerID: "ID", instrumentID: "ID", value: "f")
        )
        child3.addComponent(
            ComponentDynamicMarkingSpannerStop(performerID: "ID", instrumentID: "ID")
        )
        
        [child1, child2, child3].forEach { parent.addChild($0) }
        scoreModel.durationNodes = [parent]
        scoreModel.updateDynamicMarkingStrata()
        XCTAssert(scoreModel.dynamicMarkingStratumModels.count > 0)
        XCTAssert(scoreModel.dynamicMarkingStratumModels.first!.description == "fff > ppp < f")
    }
    
    func testScoreModelInDurationInterval() {
        var scoreModel = ScoreModel()
        let m0 = MeasureModel(duration: Duration(3,16), offsetDuration: DurationZero)
        let m1 = MeasureModel(duration: Duration(2,16), offsetDuration: Duration(3,16))
        let m2 = MeasureModel(duration: Duration(5,16), offsetDuration: Duration(5,16))
        scoreModel.measures = [m0, m1, m2]
        
        let parent = DurationNodeIntervalEnforcing(duration: Duration(3,8))
        
        let child1 = DurationNodeIntervalEnforcing(duration: Duration(1,8))
        child1.addComponent(
            ComponentDynamicMarking(performerID: "ID", instrumentID: "ID", value: "fff")
        )
        child1.addComponent(
            ComponentDynamicMarkingSpannerStart(performerID: "ID", instrumentID: "ID")
        )
        
        let child2 = DurationNodeIntervalEnforcing(duration: Duration(1,8), offsetDuration: Duration(1,8))
        child2.addComponent(
            ComponentDynamicMarking(performerID: "ID", instrumentID: "ID", value: "ppp")
        )
        child2.addComponent(
            ComponentDynamicMarkingSpannerStart(performerID: "ID", instrumentID: "ID")
        )
        child2.addComponent(
            ComponentDynamicMarkingSpannerStop(performerID: "ID", instrumentID: "ID")
        )
        
        let child3 = DurationNodeIntervalEnforcing(duration: Duration(1,8), offsetDuration: Duration(2,8))
        child3.addComponent(
            ComponentDynamicMarking(performerID: "ID", instrumentID: "ID", value: "f")
        )
        child3.addComponent(
            ComponentDynamicMarkingSpannerStop(performerID: "ID", instrumentID: "ID")
        )
        
        [child1, child2, child3].forEach { parent.addChild($0) }
        scoreModel.durationNodes = [parent]
        scoreModel.updateDynamicMarkingStrata()

        // test different duration intervals
        let di0 = DurationInterval(startDuration: DurationZero, stopDuration: Duration(1,16))
        let slice0 = scoreModel.scoreModelIn(di0)
        XCTAssert(slice0 != nil)
        XCTAssert(slice0!.dynamicMarkingStratumModels.first!.description == "fff >")
        
        let di1 = DurationInterval(startDuration: DurationZero, stopDuration: Duration(2,16))
        let slice1 = scoreModel.scoreModelIn(di1)
        XCTAssert(slice1 != nil)
        XCTAssert(slice1!.dynamicMarkingStratumModels.first!.description == "fff > ppp")
        
        let di2 = DurationInterval(startDuration: DurationZero, stopDuration: Duration(3,16))
        let slice2 = scoreModel.scoreModelIn(di2)
        XCTAssert(slice2 != nil)
        XCTAssert(slice2!.dynamicMarkingStratumModels.first!.description == "fff > ppp <")
        
        let di3 = DurationInterval(startDuration: DurationZero, stopDuration: Duration(4,16))
        let slice3 = scoreModel.scoreModelIn(di3)
        XCTAssert(slice3 != nil)
        XCTAssert(slice3!.dynamicMarkingStratumModels.first!.description == "fff > ppp < f")
        
        let di4 = DurationInterval(startDuration: Duration(1,16), stopDuration: Duration(4,16))
        let slice4 = scoreModel.scoreModelIn(di4)
        XCTAssert(slice4 != nil)
        XCTAssert(slice4!.dynamicMarkingStratumModels.first!.description == "> ppp < f")
        
        let di5 = DurationInterval(startDuration: Duration(2,16), stopDuration: Duration(4,16))
        let slice5 = scoreModel.scoreModelIn(di5)
        XCTAssert(slice5 != nil)
        XCTAssert(slice5!.dynamicMarkingStratumModels.first!.description == "ppp < f")
        
        let di6 = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(4,16))
        let slice6 = scoreModel.scoreModelIn(di6)
        XCTAssert(slice6 != nil)
        XCTAssert(slice6!.dynamicMarkingStratumModels.first!.description == "f")
        
        let di7 = DurationInterval(startDuration: Duration(3,16), stopDuration: Duration(7,32))
        let slice7 = scoreModel.scoreModelIn(di7)
        XCTAssert(slice7 != nil)
        XCTAssert(slice7!.dynamicMarkingStratumModels.first!.description == "<")
    }
}
