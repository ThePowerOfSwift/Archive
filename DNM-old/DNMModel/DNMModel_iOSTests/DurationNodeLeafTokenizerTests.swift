//
//  DurationNodeLeafTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationNodeLeafTokenizerTests: XCTestCase {

    func testNoArguments() {
        let scanner = NSScanner(string: "")
        let tokenizer = DurationNodeLeafTokenizer(scanner: scanner, relativeDurationToken: makeRelativeDurationToken())
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testDynamicMarkingSpannerStart() {
        let string = "-d fff ["
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeLeafTokenizer(scanner: scanner, relativeDurationToken: makeRelativeDurationToken())
        let token = try? tokenizer.makeToken()
        if let tokenContainer = token as? TokenContainer {
            XCTAssertEqual(tokenContainer.tokens.count, 2)
        } else {
            XCTFail()
        }
    }
    
    func testDynamicMarkingSpannerStop() {
        let string = "-d p ]"
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeLeafTokenizer(scanner: scanner, relativeDurationToken: makeRelativeDurationToken())
        let token = try? tokenizer.makeToken()
        if let tokenContainer = token as? TokenContainer {
            XCTAssertEqual(tokenContainer.tokens.count, 2)
        } else {
            XCTFail()
        }
    }
    
    func testNode() {
        let scanner = NSScanner(string: "•")
        let tokenizer = DurationNodeLeafTokenizer(scanner: scanner, relativeDurationToken: makeRelativeDurationToken())
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testEdge() {
        let scanner = NSScanner(string: "~")
        let tokenizer = DurationNodeLeafTokenizer(scanner: scanner, relativeDurationToken: makeRelativeDurationToken())
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testEdgeStop() {
        let scanner = NSScanner(string: "ø")
        let tokenizer =  DurationNodeLeafTokenizer(scanner: scanner, relativeDurationToken: makeRelativeDurationToken())
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testNodeInContext() {
        let string = "\t1 •"
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeLeafTokenizer(scanner: scanner, relativeDurationToken: makeRelativeDurationToken())
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testEdgeInContext() {
        let string = "\t1 ~"
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeLeafTokenizer(scanner: scanner, relativeDurationToken: makeRelativeDurationToken())
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }

    func testSinglePitch() {
        let string = "-p 60"
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeLeafTokenizer(scanner: scanner, relativeDurationToken: makeRelativeDurationToken())
        do {
            let token = try tokenizer.makeToken()
            XCTAssertNotNil(token)
        } catch _ {
            XCTFail()
        }
    }
    
    func testPitchFollowedByArticulation() {
        let string = "-p 60 -a ."
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeLeafTokenizer(scanner: scanner, relativeDurationToken: makeRelativeDurationToken())
        let tokenContainer = try! tokenizer.makeToken() as! TokenContainer
        XCTAssertEqual(tokenContainer.tokens.count, 3)

    }
    
    func testSinglePitchAndSingleArticulation() {
        ["-p a -a .", "-a . > -p 60 eb a5"].forEach {
            let scanner = NSScanner(string: $0)
            let tokenizer = DurationNodeLeafTokenizer(
                scanner: scanner, relativeDurationToken: makeRelativeDurationToken()
            )
            do {
                let token = try tokenizer.makeToken()
                if let tokenContainer = token as? TokenContainer {
                    XCTAssertEqual(tokenContainer.tokens.count, 3)
                } else {
                    XCTFail()
                }
            } catch _ {
                XCTFail()
            }
        }
    }
    
    func testDynamicMarkingValid() {
        ["-d fff", "-d ppp", "-d pppfff", "-d ofpppp"].forEach {
            let scanner = NSScanner(string: $0)
            let tokenizer = DurationNodeLeafTokenizer(scanner: scanner, relativeDurationToken: makeRelativeDurationToken())
            let token = try? tokenizer.makeToken()
            XCTAssertNotNil(token)
        }
    }
    
    func makeRelativeDurationToken() -> TokenFloat {
        return TokenFloat(identifier: "LeafDuration", value: 1, startIndex: 0, stopIndex: 0)
    }
}
