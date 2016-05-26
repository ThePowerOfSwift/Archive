//
//  StringExtensionsTests.swift
//  DNMModel
//
//  Created by James Bean on 1/19/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class StringExtensionsTests: XCTestCase {

    func testIndentSingleLineSingleIndent() {
        var string = "abc"
        string = string.indent(amount: 1)
        XCTAssert(string == "\tabc")
    }
    
    func testIndentSingleLineMultipleIndent() {
        var string = "abc"
        string = string.indent(amount: 3)
        XCTAssert(string == "\t\t\tabc")
    }
    
    func testIndentTwoLineSingleIndent() {
        var string = "abc\nabc"
        string = string.indent(amount: 1)
        XCTAssert(string == "\tabc\n\tabc")
    }
    
    func testIndentMultipleLinesMultipleIndents() {
        var string = "abc\nabc\nabc\nabc"
        string = string.indent(amount: 2)
        XCTAssert(string == "\t\tabc\n\t\tabc\n\t\tabc\n\t\tabc")
    }
}
