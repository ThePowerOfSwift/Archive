
//
//  ArticulationMarkingCommandTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class ArticulationMarkingCommandTokenizerTests: XCTestCase {

    func testNoMarkings() {
        let string = ""
        let scanner = NSScanner(string: string)
        let tokenizer = ArticulationMarkingCommandTokenizer(scanner: scanner)
        do {
            let token = try tokenizer.makeToken()
            XCTAssertNil(token)
        } catch Tokenizer.Error.NoArgumentsFound {
            // correct error
        } catch _ {
            XCTFail()
        }
    }
    
    func testSingleMarking() {
        let string = ">"
        let scanner = NSScanner(string: string)
        let tokenizer = ArticulationMarkingCommandTokenizer(scanner: scanner)
        let articulationContainer = try? tokenizer.makeToken() as? TokenContainer
        if let container = articulationContainer {
            if let token = container?.tokens.first as? TokenString {
                XCTAssertEqual(token.value, ">")
            }
        } else {
            XCTFail()
        }
    }
    
    func testIdentifier() {
        let string = ">"
        let scanner = NSScanner(string: string)
        let tokenizer = ArticulationMarkingCommandTokenizer(scanner: scanner)
        let articulationContainer = try! tokenizer.makeToken()
        XCTAssertEqual(articulationContainer.identifier, "Articulation")
    }
    
    func testMultipleMarkings() {
        let string = "> - ."
        let scanner = NSScanner(string: string)
        let tokenizer = ArticulationMarkingCommandTokenizer(scanner: scanner)
        let articulationContainer = try? tokenizer.makeToken() as? TokenContainer
        if let container = articulationContainer {
            let tokens: [TokenString] = container!.tokens.flatMap { $0 as? TokenString }
            let actual = tokens.map { $0.value }
            let expected: [String] = [">", "-", "."]
            XCTAssertEqual(actual, expected)
        } else {
            XCTFail()
        }
    }
}
