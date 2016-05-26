//
//  InstrumentTypeTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class InstrumentTypeTokenizerTests: XCTestCase {

    func testValid() {
        ["Violin", "Flute_Piccolo", "Contrabass", "Clarinet_Bflat"].forEach {
            let scanner = NSScanner(string: $0)
            let tokenizer = InstrumentTypeTokenizer(scanner: scanner)
            let token = try? tokenizer.makeToken()
            XCTAssertNotNil(token)
        }
    }
    
    func testInvalid() {
        ["Vilin", "Flute.Piccolo", "flute_c", "cello"].forEach {
            let scanner = NSScanner(string: $0)
            let tokenizer = InstrumentTypeTokenizer(scanner: scanner)
            let token = try? tokenizer.makeToken()
            XCTAssertNil(token)
        }
    }
}
