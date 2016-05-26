//
//  DictionaryExtensionsTests.swift
//  DNMModel
//
//  Created by James Bean on 1/11/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DictionaryExtensionsTests: XCTestCase {

    func testEnsureArrayValueForKey() {
        var dict: [String: [String]] = ["one": ["won", "1"]]
        dict.ensureArrayValueFor("two")
        XCTAssert(dict["two"] != nil)
        XCTAssert(dict["two"]! == [])
    }
    
    func testSafelyAppendValueInArray() {
        var dict: [String: [String]] = ["one": ["won", "1"]]
        dict.safelyAppend("too", toArrayWithKey: "two")
        XCTAssert(dict["two"] != nil)
        XCTAssert(dict["two"]! == ["too"])
    }
    
    func testEnsureValueInArrayInDictionary() {
        var dict: [String: [String: [String]]] = [:]
        dict["one"] = [:]
        dict["one"]!.safelyAppend("vuhn", toArrayWithKey: "won")
        XCTAssert(dict["one"]!["won"] != nil)
        XCTAssert(dict["one"]!["won"]! == ["vuhn"])
    }
    
    func testEnsureDictionaryValueForKey() {
        var dict: [String: [String: [String]]] = [:]
        dict.ensureDictionaryValueFor("hope")
        XCTAssert(dict["hope"] != nil)
        XCTAssert(dict["hope"]!.count == 0)
    }
    
    func testSafelyAndUniquelyAppendValueTypeToArrayValue() {
        var dict: [String: [String]] = ["one": ["won"]]
        dict.safelyAndUniquelyAppend("1", toArrayWithKey: "one")
        XCTAssert(dict["one"] != nil)
        XCTAssert(dict["one"]! == ["won", "1"])
        
        dict.safelyAndUniquelyAppend("1", toArrayWithKey: "one")
        XCTAssert(dict["one"] != nil)
        XCTAssert(dict["one"]! == ["won", "1"])
    }
    
    func testSafelyAppendValueTypeToDictionaryWithKeyPath() {
        var dict: [String: [String: [String]]] = [:]
        dict.safelyAppend("key here", toArrayWithKeyPath: KeyPath(["Put", "this"]))
        XCTAssert(dict["Put"] != nil)
        XCTAssert(dict["Put"]!["this"] != nil)
        XCTAssert(dict["Put"]!["this"]! == ["key here"])
    }
    
    func testDeepMerge() {
        let dict0 = ["One": ["won": ["1", "vun", "ton"]]]
        let dict1 = [
            "One": ["won": ["vun", "bun"]],
            "Two": ["to": ["too"]]
        ]
        let mergedDict = dict0.mergeWith(dict1)
        XCTAssert(
            mergedDict == ["One": ["won": ["1", "vun", "ton", "bun"]], "Two": ["to": ["too"]]]
        )
    }
}
