//
//  RelativeDurationTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class RelativeDurationTokenizerTests: XCTestCase {

    func testLeafDuration() {
        let string = "5"
        let scanner = NSScanner(string: string)
        let tokenizer = RelativeDurationTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testInternalDuration() {
        let string = "5 --"
        let scanner = NSScanner(string: string)
        let tokenizer = RelativeDurationTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testInvalid() {
        let string = "k --"
        let scanner = NSScanner(string: string)
        let tokenizer = RelativeDurationTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testIdentifierLeaf() {
        let string = "5"
        let scanner = NSScanner(string: string)
        let tokenizer = RelativeDurationTokenizer(scanner: scanner)
        let token = try! tokenizer.makeToken()
        XCTAssertEqual(token.identifier, "LeafRelativeDuration")
    }
    
    func testIdentifierInternal() {
        let string = "5 --"
        let scanner = NSScanner(string: string)
        let tokenizer = RelativeDurationTokenizer(scanner: scanner)
        let token = try! tokenizer.makeToken()
        XCTAssertEqual(token.identifier, "InternalRelativeDuration")
    }
}
