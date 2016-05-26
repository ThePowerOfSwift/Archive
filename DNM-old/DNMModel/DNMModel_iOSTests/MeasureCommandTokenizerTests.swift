//
//  MeasureCommandTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class MeasureCommandTokenizerTests: XCTestCase {

    func testNoDuration() {
        let string = ""
        let scanner = NSScanner(string: string)
        let tokenizer = MeasureCommandTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testWithDuration() {
        let string = " 3,16"
        let scanner = NSScanner(string: string)
        let tokenizer = MeasureCommandTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        if let tokenContainer = token as? TokenContainer {
            XCTAssertEqual(tokenContainer.tokens.count, 1)
        } else {
            XCTFail()
        }
    }
    
    func testIdentifier() {
        let string = " 3,16"
        let scanner = NSScanner(string: string)
        let tokenizer = MeasureCommandTokenizer(scanner: scanner)
        let token = try! tokenizer.makeToken()
        XCTAssertEqual(token.identifier, "Measure")
    }
    
    func testWithInvalidDuration() {
        let string = " 3,kl"
        let scanner = NSScanner(string: string)
        let tokenizer = MeasureCommandTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            XCTAssertNotNil(token)
        } catch Tokenizer.Error.InvalidDurationArgument {
            // correct error
        } catch _ {
            XCTFail()
        }
    }
}
