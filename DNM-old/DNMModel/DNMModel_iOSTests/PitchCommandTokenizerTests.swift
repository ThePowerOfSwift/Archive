//
//  PitchCommandTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class PitchCommandTokenizerTests: XCTestCase {

    func testNoPitches() {
        let string = ""
        let scanner = NSScanner(string: string)
        let tokenizer = PitchCommandTokenizer(scanner: scanner)
        do {
            try tokenizer.makeToken()
            XCTFail()
        } catch Tokenizer.Error.NoArgumentsFound {
            // correct error
        } catch _ {
            XCTFail()
        }
    }
    
    func testSinglePitch_60() {
        let string = "60"
        let scanner = NSScanner(string: string)
        let tokenizer = PitchCommandTokenizer(scanner: scanner)
        do {
            let pitchTokenContainer = try tokenizer.makeToken() as! TokenContainer
            XCTAssertEqual(pitchTokenContainer.identifier, "Pitch")
            if let firstToken = pitchTokenContainer.tokens.first as? TokenFloat {
                XCTAssertEqual(firstToken.value, 60.0)
            } else {
                XCTFail()
            }
        } catch {
            XCTFail()
        }
    }
    
    func testSinglePitch_c() {
        let string = "c"
        let scanner = NSScanner(string: string)
        let tokenizer = PitchCommandTokenizer(scanner: scanner)
        do {
            let pitchTokenContainer = try tokenizer.makeToken() as! TokenContainer
            XCTAssertEqual(pitchTokenContainer.identifier, "Pitch")
            if let firstToken = pitchTokenContainer.tokens.first as? TokenFloat {
                XCTAssertEqual(firstToken.value, 60.0)
            } else {
                XCTFail()
            }
        } catch {
            XCTFail()
        }
    }
    
    func testMultiplePitches() {
        let string = "eqb c5 80.25"
        let scanner = NSScanner(string: string)
        let tokenizer = PitchCommandTokenizer(scanner: scanner)
        do {
            let pitchContainer = try tokenizer.makeToken() as! TokenContainer
            XCTAssertEqual(pitchContainer.identifier, "Pitch")
            let tokens = pitchContainer.tokens.flatMap { $0 as? TokenFloat }
            let actual = tokens.map { $0.value }
            let expected: [Float] = [63.5, 72, 80.25]
            XCTAssertEqual(actual, expected)
        } catch {
            XCTFail()
        }
    }
    
    func testComplex() {
        let string = "d_qf_up"
        let scanner = NSScanner(string: string)
        let tokenizer = PitchCommandTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
    }
}
