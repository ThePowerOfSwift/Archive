//
//  DurationTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationTokenizerTests: XCTestCase {

    func testDurationValid() {
        let string = "9,16"
        let scanner = NSScanner(string: string)
        let tokenizer = MetricalDurationTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testDurationInvalidBeats() {
        let string = "j,16"
        let scanner = NSScanner(string: string)
        let tokenizer = MetricalDurationTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testDurationInvalidNoSeparator() {
        let string = "1116"
        let scanner = NSScanner(string: string)
        let tokenizer = MetricalDurationTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testDurationInvalidSubdivision() {
        let string = "19,lk"
        let scanner = NSScanner(string: string)
        let tokenizer = MetricalDurationTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
}
