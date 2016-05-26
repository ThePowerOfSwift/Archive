//
//  DurationNodeRootTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationNodeRootTokenizerTests: XCTestCase {

    func testNoArguments() {
        let tokenizer = DurationNodeRootTokenizer(scanner: NSScanner(string: ""))
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testDurationValid() {
        let string = "3,8 VN vn"
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeRootTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testInferringValid() {
        let string = "@ FL fl"
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeRootTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testIdentifier() {
        ["3,8 VN vn", "@ VN vn"].forEach {
            let scanner = NSScanner(string: $0)
            let tokenizer = DurationNodeRootTokenizer(scanner: scanner)
            let token = try! tokenizer.makeToken()
            XCTAssertEqual(token.identifier, "DurationNodeRoot")
        }
    }
    
    func testNoPerformerID() {
        let tokenizer = DurationNodeRootTokenizer(scanner: NSScanner(string: "1,8"))
        do {
            let token = try tokenizer.makeToken()
            XCTAssertNil(token)
        } catch Tokenizer.Error.InvalidPerformerID {
            // correct error
        } catch _ {
            XCTFail()
        }
    }
    
    func testNoInstrumentID() {
        let tokenizer = DurationNodeRootTokenizer(scanner: NSScanner(string: "1,8 VN"))
        do {
            let token = try tokenizer.makeToken()
            XCTAssertNil(token)
        } catch Tokenizer.Error.InvalidInstrumentID {
            // correct error
        } catch _ {
            XCTFail()
        }
    }
}