//
//  DurationNodeStackModeMeasureCommandTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DurationNodeStackModeMeasureCommandTokenizerTests: XCTestCase {

    func testIdentifier() {
        let string = "1,8 VN vn"
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeStackModeMeasureCommandTokenizer(scanner: scanner)
        let token = try! tokenizer.makeToken()
        XCTAssertEqual(token.identifier, "DurationNodeStackModeMeasure")
    }
    
    func testNoDurationNode() {
        let string = ""
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeStackModeMeasureCommandTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            XCTAssertNil(token)
        } catch Tokenizer.Error.InvalidDurationNodeRootArgument {
            // correct error
        } catch {
            XCTFail()
        }
    }
    
    func testNoPerformerID() {
        let string = "1,8"
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeStackModeMeasureCommandTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            XCTAssertNil(token)
        } catch Tokenizer.Error.InvalidPerformerID {
            // correct error
        } catch {
            XCTFail()
        }
    }
    
    func testNoInstrumentID() {
        let string = "1,8 FL"
        let scanner = NSScanner(string: string)
        let tokenizer = DurationNodeStackModeMeasureCommandTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            XCTAssertNil(token)
        } catch Tokenizer.Error.InvalidInstrumentID {
            // correct error
        } catch {
            XCTFail()
        }
    }
}
