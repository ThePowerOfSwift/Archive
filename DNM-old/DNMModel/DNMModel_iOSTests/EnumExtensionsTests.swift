//
//  EnumExtensionsTests.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class EnumExtensionsTests: XCTestCase {

    func testEnumerateIntEnum() {
        enum IntEnum: Int {
            case One = 1
            case Two = 2
            case Three = 3
        }

        let expected: [Int] = [1,2,3]
        let actual: [Int] = iterateEnum(IntEnum).map { $0.rawValue }
        XCTAssertEqual(expected, actual)
    }
    
    func testEnumerateStringEnum() {
        enum StringEnum: String {
            case One = "Won"
            case Two = "Too"
            case Three = "Free"
        }
        
        let expected: [String] = ["Won", "Too", "Free"]
        let actual: [String] = iterateEnum(StringEnum).map { $0.rawValue }
        XCTAssertEqual(expected, actual)
    }
}
