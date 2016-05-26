//
//  NodeCommandTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class NodeCommandTokenizerTests: XCTestCase {

    func testIdentifier() {
        let token = try! NodeCommandTokenizer(scanner: NSScanner(string: "")).makeToken()
        XCTAssertEqual(token.identifier, "Node")
    }
}
