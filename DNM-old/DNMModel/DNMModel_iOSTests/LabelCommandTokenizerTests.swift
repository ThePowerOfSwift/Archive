//
//  LabelCommandTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/29/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class LabelCommandTokenizerTests: XCTestCase {

    func testStringValid() {
        let string = "'pizz'"
        let tokenizer = LabelCommandTokenizer(scanner: NSScanner(string: string))
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testStringNoOpeningQuotationMark() {
        let string = "pizz'"
        let tokenizer = LabelCommandTokenizer(scanner: NSScanner(string: string))
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testStringNoClosingQuotationMark() {
        let string = "'pizz"
        let tokenizer = LabelCommandTokenizer(scanner: NSScanner(string: string))
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
}
