//
//  _ParserTests.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DNMParserTests: XCTestCase {

    func testNoArguments() {
        let string = ""
        let scoreModel = scoreModelFrom(string)
        XCTAssertNotNil(scoreModel)
    }
    
    func testMeasures() {
        let string = "# 3,16\n# 2,8\n# 9,16"
        if let scoreModel = scoreModelFrom(string) {
            print("Measures score model: \(scoreModel)")
        } else {
            XCTFail()
        }
    }
    
    func testPerformerDeclarationSinglePerformerSingleInstrument() {
        let string = "\nP: VN vn Violin\n"
        if let scoreModel = scoreModelFrom(string) {
            XCTAssertEqual(scoreModel.instrumentTypeModel.count, 1)
        } else {
            XCTFail()
        }
    }
    
    func testPerformerDeclarationSinglePerformerMultipleInstruments() {
        let string = "\nP: VN vn Violin sw BinarySwitch fp ContinuousController\n"
        if let scoreModel = scoreModelFrom(string) {
            XCTAssertEqual(scoreModel.instrumentTypeModel.count, 1)
        } else {
            XCTFail()
        }
    }
    
    func testPerformerDeclarationMultiplePerformersWithMultipleInstruments() {
        let string = "\nP: VN vn Violin sw BinarySwitch\nP: VC vc Violoncello cc ContinuousController"
        if let scoreModel = scoreModelFrom(string) {
            XCTAssertEqual(scoreModel.instrumentTypeModel.count, 2)
        } else {
            XCTFail()
        }
    }
    
    func testMeasureNoDuration() {
        let string = "#"
        if let scoreModel = scoreModelFrom(string) {
            XCTAssertEqual(scoreModel.measures.count, 1)
        } else {
            XCTFail()
        }
    }
    
    func testMeasureWithDuration() {
        let string = "# 3,16"
        if let scoreModel = scoreModelFrom(string) {
            if let firstMeasure = scoreModel.measures.first {
                XCTAssertEqual(firstMeasure.duration, Duration(3,16))
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testDurationNodeEnforcing() {
        let string = "| 3,16 VN vn"
        if let scoreModel = scoreModelFrom(string) {
            XCTAssertEqual(scoreModel.durationNodes.count, 1)
        } else {
            XCTFail()
        }
    }

    func testDurationNodeEnforcingStacking() {
        let string = "| 3,16 VN vn\n+ 2,8 VN vn"
        if let scoreModel = scoreModelFrom(string) {
            XCTAssertEqual(scoreModel.durationNodes.count, 2)
            XCTAssertEqual(
                (scoreModel.durationNodes[1] as! DurationNodeIntervalEnforcing).offsetDuration,
                Duration(3,16)
            )
        } else {
            XCTFail()
        }
    }

    func testDurationNodeEnforcingStackingMeasure() {
        let string = "| 3,16 VN vn\n+ 2,8 VN vn\n| 1,8 VC vc 4,8"
        if let scoreModel = scoreModelFrom(string) {
            XCTAssertEqual(scoreModel.durationNodes.count, 3)
            XCTAssertEqual(
                (scoreModel.durationNodes[2] as! DurationNodeIntervalEnforcing).offsetDuration,
                DurationZero
            )
        } else {
            XCTFail()
        }
    }
    
    func testDurationNodeInferring() {
        let string = "+ @ VN vn\n\t1.25 •\n\t1.625 ~"
        if let scoreModel = scoreModelFrom(string) {
            if let firstDurationNodeRoot = scoreModel.durationNodes.first {
                XCTAssertEqual(firstDurationNodeRoot.children.count, 2)
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testDurationNodeInferringEventAt0() {
        let string = "# 2,8\n+ @ VN vn\n\t0.0 •"
        if let scoreModel = scoreModelFrom(string) {
            if let firstDurationNode = scoreModel.durationNodes.first {
                XCTAssertEqual(
                    firstDurationNode.childAt(0)!.durationInterval.startDuration,
                    DurationZero
                )
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testDurationNodeInferringStacking() {
        let string = "# 2,8\n+ @ VN vn\n\t0.0 •\n# 2,8\n+ @ VN vn\n\t2.0 •"
        if let scoreModel = try? ScoreModel(string: string) {
            print("inferring stacking: \(scoreModel)")
        } else {
            XCTFail()
        }
    }
    
    func testEdgeStop() {
        let string = "+ @ VN vn\n\t0 ~\n\t1 ø"
        if let scoreModel = scoreModelFrom(string) {
            XCTAssertEqual(scoreModel.durationNodes.count, 1)
            XCTAssertEqual(scoreModel.durationNodes.first!.children.count, 1)
            XCTAssertEqual(
                (scoreModel.durationNodes.first!.children.first as! DurationNodeIntervalEnforcing).duration,
                Duration(1,8)
            )
        } else {
            XCTFail()
        }
    }
    
    func testLeafPitch() {
        let string = "| 1,8 VN vn\n\t1 -p 60"
        if let scoreModel = scoreModelFrom(string) {
            XCTAssertEqual(scoreModel.durationNodes.count, 1)
            XCTAssertEqual(scoreModel.durationNodes.first!.children.count, 1)
        } else {
            XCTFail()
        }
    }

    func testLeafPitchAndArticulation() {
        let string = "| 1,8 VN vn\n\t1 -p 60 c#7 bqb_up3 -a . >"
        if let scoreModel = scoreModelFrom(string) {
            XCTAssertEqual(scoreModel.durationNodes.count, 1)
            XCTAssertEqual(scoreModel.durationNodes.first!.children.count, 1)
        } else {
            XCTFail()
        }
    }
    
    func testLabel() {
        let string = "| 1,8 VN vn\n\n\t1 -p c -l 'pizz' -d fff"
        if let scoreModel = scoreModelFrom(string) {
            XCTAssertEqual(scoreModel.durationNodes.count, 1)
            if let leaf = scoreModel.durationNodes.first!.children.first as? DurationNode {
                XCTAssertEqual(leaf.components.count, 3)
                XCTAssertTrue(leaf.hasComponentWithIdentifier("Label"))
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    private func scoreModelFrom(string: String) -> ScoreModel? {
        let scanner = NSScanner(string: string)
        let tokenizer = Tokenizer(scanner: scanner)
        if let tokenContainer = try? tokenizer.makeToken() as! TokenContainer {
            let parser = DNMParser()
            let scoreModel = try? parser.parseRoot(tokenContainer)
            return scoreModel
        }
        return nil
    }
}
