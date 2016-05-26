//
//  InstrumentDeclarationTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class InstrumentDeclarationTokenizerTests: XCTestCase {

    func testValid() {
        let string = "vn Violin"
        let scanner = NSScanner(string: string)
        let tokenizer = InstrumentDeclarationTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
        if let tokenContainer = token as? TokenContainer {
            XCTAssertEqual(tokenContainer.tokens.count, 2)
        }
    }
    
    func testInvalidInstrumentID() {
        let string = "v/n Violin"
        let scanner = NSScanner(string: string)
        let tokenizer = InstrumentDeclarationTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            XCTAssertNil(token)
        } catch let error {
            print(error)
        }
    }
    
    func testInvalidInstrumentType() {
        let string = "vn biolon"
        let scanner = NSScanner(string: string)
        let tokenizer = InstrumentDeclarationTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            XCTAssertNil(token)
        } catch Tokenizer.Error.InvalidInstrumentType(let message) {
            XCTAssertEqual(message, "Unsupported InstrumentType: biolon")
        } catch _ {
            XCTFail()
        }
    }
}
