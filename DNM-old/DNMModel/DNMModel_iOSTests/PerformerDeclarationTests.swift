//
//  PerformerDeclarationTests.swift
//  DNMModel
//
//  Created by James Bean on 1/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class PerformerDeclarationTests: XCTestCase {

    func testUpdateTypeWithID() {
        var declaration = PerformerDeclaration(performerID: "VN")
        declaration.updateType(.Violin, forInstrumentID: "vn")
        XCTAssert(declaration.instrumentTypeByID["vn"] == .Violin)
    }
    
}
