//
//  LineTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class LineTokenizerTests: XCTestCase {

    func testEmpty() {
        let string = ""
        let scanner = NSScanner(string: string)
        let tokenizer = LineTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            XCTAssertNil(token)
        } catch Tokenizer.Error.NoArgumentsFound {
            // corret error
        } catch _ {
            XCTFail()
        }
    }
    
    func testNewLine() {
        let string = "\n"
        let scanner = NSScanner(string: string)
        let tokenizer = LineTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testNewLineWithContentsBeforeValid() {
        let string = "-p 60\n"
        let scanner = NSScanner(string: string)
        let tokenizer = LineTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
        if let tokenContainer = token as? TokenContainer {
            XCTAssertEqual(tokenContainer.tokens.count, 1)
        } else {
            XCTFail()
        }
    }
    
    func testNewLineWithContentsAfterValid() {
        let string = "-p 60\n-a ."
        let scanner = NSScanner(string: string)
        let tokenizer = LineTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
        if let tokenContainer = token as? TokenContainer {
            XCTAssertEqual(tokenContainer.tokens.count, 1)
        } else {
            XCTFail()
        }
    }
    
    func testPerformerDeclaration() {
        let string = "P: VN vn Violin sw BinarySwitch cc ContinuousController"
        let scanner = NSScanner(string: string)
        let tokenizer = LineTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            if let tokenContainer = token as? TokenContainer {
                XCTAssertEqual(tokenContainer.tokens.count, 1)
            }
        } catch {
            XCTFail()
        }
    }

    func testDurationNodeStackModeMeasure() {
        let tokenizer = LineTokenizer(scanner: NSScanner(string: "| 1,8 VN vn"))
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testDuraitonNodeStackModeIncrement() {
        let tokenizer = LineTokenizer(scanner: NSScanner(string: "+ 1,8 VN vn"))
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testLineComment() {
        let string = "-p 60 -d fff // -a ."
        let tokenizer = LineTokenizer(scanner: NSScanner(string: string))
        let tokenContainer = try! tokenizer.makeToken() as! TokenContainer
        if let secondToken = tokenContainer.tokens[safe: 1] {
            XCTAssertEqual(secondToken.identifier, "LineComment")
        } else {
            XCTFail()
        }
    }
}
