//
//  EdgeCommandTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/24/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class EdgeCommandTokenizerTests: XCTestCase {
    
    func testIdentifier() {
        let token = try! EdgeCommandTokenizer(scanner: NSScanner(string: "")).makeToken()
        XCTAssertEqual(token.identifier, "Edge")
    }
}
