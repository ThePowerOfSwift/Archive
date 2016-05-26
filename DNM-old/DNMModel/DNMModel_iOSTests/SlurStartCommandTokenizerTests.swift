//
//  SlurStartCommandTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class SlurStartCommandTokenizerTests: XCTestCase {

    func testIdentifier() {
        let token = SlurStartCommandTokenizer(scanner: NSScanner(string: ""))
        XCTAssertEqual(token.identifier, "SlurStart")
    }
}
