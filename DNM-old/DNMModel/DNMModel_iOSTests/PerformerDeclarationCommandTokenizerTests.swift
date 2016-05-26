//
//  PerformerDeclarationCommandTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class PerformerDeclarationCommandTokenizerTests: XCTestCase {

    func testNoArguments() {
        let string = ""
        let scanner = NSScanner(string: string)
        let tokenizer = PerformerDeclarationCommandTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testValidSingleInstrument() {
        let string = "VN vn Violin"
        let scanner = NSScanner(string: string)
        let tokenizer = PerformerDeclarationCommandTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            if let container = token as? TokenContainer {
                XCTAssertEqual(container.tokens.count, 2)
            } else {
                XCTFail()
            }
            XCTAssertNotNil(token)
        } catch {
            XCTFail()
        }
    }
    
    func testIdentifier() {
        let string = "VN vn Violin"
        let scanner = NSScanner(string: string)
        let tokenizer = PerformerDeclarationCommandTokenizer(scanner: scanner)
        let token = try! tokenizer.makeToken()
        XCTAssertEqual(token.identifier, "PerformerDeclaration")
    }
    
    func testValidMultipleInstruments() {
        let string = "VN vn Violin sw BinarySwitch"
        let scanner = NSScanner(string: string)
        let tokenizer = PerformerDeclarationCommandTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            if let container = token as? TokenContainer {
                XCTAssertEqual(container.tokens.count, 3)
            } else {
                XCTFail()
            }
            XCTAssertNotNil(token)
        } catch {
            XCTFail()
        }
    }
    
    func testInvalidPerformerID() {
        let string = "V($ vn Violin sw BinarySwitch"
        let scanner = NSScanner(string: string)
        let tokenizer = PerformerDeclarationCommandTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
}
