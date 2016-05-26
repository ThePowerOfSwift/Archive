//
//  DynamicMarkingCommandTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DynamicMarkingCommandTokenizerTests: XCTestCase {

    func testNoArguments() {
        let string = ""
        let scanner = NSScanner(string: string)
        let tokenizer = DynamicMarkingCommandTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testValid() {
        ["fff", "ppp", "o", "mfo", "pfffmp"].forEach {
            let scanner = NSScanner(string: $0)
            let tokenizer = DynamicMarkingCommandTokenizer(scanner: scanner)
            let token = try? tokenizer.makeToken()
            XCTAssertNotNil(token)
        }
    }
    
    func testIdentifier() {
        let string = "fff"
        let scanner = NSScanner(string: string)
        let tokenizer = DynamicMarkingCommandTokenizer(scanner: scanner)
        let token = try! tokenizer.makeToken()
        XCTAssertEqual(token.identifier, "DynamicMarking")
    }
    
    func testInvalid() {
        ["klll", "pd", ".,", "", "pl"].forEach {
            let scanner = NSScanner(string: $0)
            let tokenizer = DynamicMarkingCommandTokenizer(scanner: scanner)
            let token = try? tokenizer.makeToken()
            XCTAssertNil(token)
        }
    }
    
    func testSpannerStart() {
        let string = "ppp ["
        let scanner = NSScanner(string: string)
        let tokenizer = DynamicMarkingCommandTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            if let tokenContainer = token as? TokenContainer {
                XCTAssertEqual(tokenContainer.tokens.count, 2)
                if let secondToken = tokenContainer.tokens.second {
                    XCTAssertEqual(secondToken.identifier, "SpannerStart")
                } else {
                    XCTFail()
                }
            }
        } catch {
            XCTFail()
        }
    }
    
    func testSpannerStop() {
        let string = "ppp ]"
        let scanner = NSScanner(string: string)
        let tokenizer = DynamicMarkingCommandTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            if let tokenContainer = token as? TokenContainer {
                XCTAssertEqual(tokenContainer.tokens.count, 2)
                if let secondToken = tokenContainer.tokens.second {
                    XCTAssertEqual(secondToken.identifier, "SpannerStop")
                } else {
                    XCTFail()
                }
            }
        } catch {
            XCTFail()
        }
    }
}
