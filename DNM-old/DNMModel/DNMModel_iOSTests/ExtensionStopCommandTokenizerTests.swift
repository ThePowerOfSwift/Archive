//
//  ExtensionStopCommandTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class ExtensionStopCommandTokenizerTests: XCTestCase {

    func testIdentifier() {
        let token = ExtensionStopCommandTokenizer(scanner: NSScanner(string: ""))
        XCTAssertEqual(token.identifier, "ExtensionStop")
    }
}
