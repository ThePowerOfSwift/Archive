//
//  DNMTokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 11/22/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class DNMTokenizerTests: XCTestCase {
    
    func testInit() {
        let t = DNMTokenizer()
        print(t)
    }
    
    func testTokenizePitchFloat() {
        let string = "p 60.25"
        let t = DNMTokenizer()
        let tokenContainer = t.tokenizeString(string)
        
        // should have one token(container)
        XCTAssert(tokenContainer.tokens.count == 1, "tokens created incorrectly")
        
        // which is a pitch
        XCTAssert(tokenContainer.tokens.first!.identifier == "Pitch", "pitch token not created")
        
        // and is container itself
        XCTAssert(tokenContainer.tokens.first! is TokenContainer, "not token container")
        
        // and has a value
        let pitchContainer = tokenContainer.tokens.first as! TokenContainer
        XCTAssert(pitchContainer.tokens.first!.identifier == "Value", "value token not created")
        
        // ... of 60
        let pitchValueToken = pitchContainer.tokens.first as! TokenFloat
        XCTAssert(pitchValueToken.value == 60.25, "value not 60.25")
    }
    
    func testTokenizePitchString() {
        let string = "p c"
        let tokenContainer = DNMTokenizer().tokenizeString(string)
        
        if let token = tokenContainer.tokens.first as? TokenContainer {
            if let valueToken = token.tokens.first as? TokenFloat {
                XCTAssert(valueToken.value == 60)
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testTokenizerPitchStringEb5() {
        let string = "p eb5"
        let tokenContainer = DNMTokenizer().tokenizeString(string)
        if let token = tokenContainer.tokens.first as? TokenContainer {
            if let valueToken = token.tokens.first as? TokenFloat {
                XCTAssert(valueToken.value == 75)
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testTokenizerPitchStringEQSharp6() {
        let string = "p eq#6"
        let tokenContainer = DNMTokenizer().tokenizeString(string)
        if let token = tokenContainer.tokens.first as? TokenContainer {
            if let valueToken = token.tokens.first as? TokenFloat {
                XCTAssert(valueToken.value == 88.5)
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testTokenizerPitchStringBQFlatUp4() {
        let string = "p b_qb_up4"
        let tokenContainer = DNMTokenizer().tokenizeString(string)
        if let token = tokenContainer.tokens.first as? TokenContainer {
            if let valueToken = token.tokens.first as? TokenFloat {
                XCTAssert(valueToken.value == 70.75)
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testTokenizerPitchStrings() {
        let string = "Title: Test\n\nP: VN vn Violin\n\n#\n| 1,8\n\t1 p a#\n\t1 p c5"
        let tokenContainer = DNMTokenizer().tokenizeString(string)
        print(tokenContainer)
    }
    
    func testTokenizeDynamicSingleValue() {
        let string = "d offfmp"
        let t = DNMTokenizer()
        let tokenContainer = t.tokenizeString(string)
        
        // should have one token(container)
        XCTAssert(tokenContainer.tokens.count == 1, "tokens created incorrectly")
        
        // which is a dynamic
        XCTAssert(tokenContainer.tokens.first!.identifier == "DynamicMarking", "dynamic marking token not created")
        
        // and is a container itself
        XCTAssert(tokenContainer.tokens.first! is TokenContainer, "not token container")
        
        // and has a value
        let dynamicMarkingContainer = tokenContainer.tokens.first as! TokenContainer
        XCTAssert(dynamicMarkingContainer.tokens.first!.identifier == "Value", "value token not created")
        
        // of offfpp
        let dmValueToken = dynamicMarkingContainer.tokens.first as! TokenString
        XCTAssert(dmValueToken.value == "offfmp", "dynamic marking not tokenized correctly")
    }
    
    func testTokenizeDynamicWithSpanner() {
        let string = "d offfmp ["
        let t = DNMTokenizer()
        let tokenContainer = t.tokenizeString(string)
        
        // should have one token(container)
        XCTAssert(tokenContainer.tokens.count == 1, "tokens created incorrectly")
        
        // which is a dynamic
        XCTAssert(tokenContainer.tokens.first!.identifier == "DynamicMarking", "dynamic marking token not created")
        
        // and is a container itself
        XCTAssert(tokenContainer.tokens.first! is TokenContainer, "not token container")
        
        // and has a value
        let dynamicMarkingContainer = tokenContainer.tokens.first as! TokenContainer
        XCTAssert(dynamicMarkingContainer.tokens.first!.identifier == "Value", "value token not created")
        
        // of offfpp
        let dmValueToken = dynamicMarkingContainer.tokens.first as! TokenString
        XCTAssert(dmValueToken.value == "offfmp", "dynamic marking not tokenized correctly")
        
        // and contains a spanner token
        XCTAssert(dynamicMarkingContainer.tokens.second! is TokenContainer, "spanner not added")
        
        let spannerToken = dynamicMarkingContainer.tokens.second as! TokenContainer
        XCTAssert(spannerToken.identifier == "SpannerStart", "spanner start token not created")
    }
    
    func testTokenizeSlurStart() {
        let string = "("
        let t = DNMTokenizer()
        let tokenContainer = t.tokenizeString(string)
        
        // should have one token(container)
        XCTAssert(tokenContainer.tokens.count == 1, "tokens created incorrectly")
        
        // which is a slurStart
        XCTAssert(tokenContainer.tokens.first!.identifier == "SlurStart", "slur start token not created")
    }
    
    func testTokenizeExtensionStart() {
        let string = "->"
        let t = DNMTokenizer()
        let tokenContainer = t.tokenizeString(string)
        
        // should have one token(container)
        XCTAssert(tokenContainer.tokens.count == 1, "tokens created incorrectly")
        
        // which is a extension start
        XCTAssert(tokenContainer.tokens.first!.identifier == "ExtensionStart", "extension start token not created")
    }

    func testTokenizeExtensionStop() {
        let string = "<-"
        let t = DNMTokenizer()
        let tokenContainer = t.tokenizeString(string)
        
        // should have one token(container)
        XCTAssert(tokenContainer.tokens.count == 1, "tokens created incorrectly")
        
        // which is a extension stop
        XCTAssert(tokenContainer.tokens.first!.identifier == "ExtensionStop", "extension stop token not created")
    }
    
    func testTtokenizeSlurStop() {
        let string = ")"
        let t = DNMTokenizer()
        let tokenContainer = t.tokenizeString(string)
        
        // should have one token(container)
        XCTAssert(tokenContainer.tokens.count == 1, "tokens created incorrectly")
        
        // which is a slurStart
        XCTAssert(tokenContainer.tokens.first!.identifier == "SlurStop", "slur stop token not created")
    }
    
    func testTokenizeRest() {
        let string = "*"
        let t = DNMTokenizer()
        let tokenContainer = t.tokenizeString(string)
        
        // should have one token(container)
        XCTAssert(tokenContainer.tokens.count == 1, "tokens created incorrectly")
        
        // which is a slurStart
        XCTAssert(tokenContainer.tokens.first!.identifier == "Rest", "rest token not created")
    }
    
    func testTokenizeArticulationSingleValue() {
        let string = "a - . >"
        let t = DNMTokenizer()
        let tokenContainer = t.tokenizeString(string)
        
        // should have one token(container)
        XCTAssert(tokenContainer.tokens.count == 1, "tokens created incorrectly")
        
        // which is a articulation
        XCTAssert(tokenContainer.tokens.first!.identifier == "Articulation", "articulation token not created")
        
        // and is a container itself
        XCTAssert(tokenContainer.tokens.first! is TokenContainer, "not token container")
        
        // and has three values tokens
        let articulationContainer = tokenContainer.tokens.first as! TokenContainer
        XCTAssert(articulationContainer.tokens.count == 3, "all three articulations not created")
        
        let tenutoToken = articulationContainer.tokens[0] as! TokenString
        let staccatoToken = articulationContainer.tokens[1] as! TokenString
        let accentToken = articulationContainer.tokens[2] as! TokenString
        
        XCTAssert(tenutoToken.identifier == "Value", "id incorrect")
        XCTAssert(tenutoToken.value == "-", "tenuto not set correctly")
        XCTAssert(staccatoToken.identifier == "Value", "id inccorect")
        XCTAssert(staccatoToken.value == ".", "staccato not set correctly")
        XCTAssert(accentToken.identifier == "Value", "id incorrect")
        XCTAssert(accentToken.value == ">", "accent not set correctly")
    }
    
    // TODO: check start / stop values
}
