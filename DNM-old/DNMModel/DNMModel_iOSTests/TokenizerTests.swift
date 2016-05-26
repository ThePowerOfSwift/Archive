 //
//  TokenizerTests.swift
//  DNMModel
//
//  Created by James Bean on 1/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import DNMModel

class TokenizerTests: XCTestCase {

    func testTokenizeStringValid() {
        let string = "abd"
        let scanner = NSScanner(string: string)
        let tokenizer = StringTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testTokenizeStringInvalid() {
        let string = ",.$"
        let scanner = NSScanner(string: string)
        let tokenizer = StringTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testScannerUnwoundInCaseOfFailure() {
        let string = ",';.,"
        let scanner = NSScanner(string: string)
        let tokenizer = StringTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
        XCTAssertEqual(scanner.scanLocation, 0)
    }
    
    func testTokenRange() {
        let string = "abd"
        let scanner = NSScanner(string: string)
        let tokenizer = StringTokenizer(scanner: scanner)
        let token = try! tokenizer.makeToken()
        XCTAssertEqual(token.startIndex, 0)
        XCTAssertEqual(token.stopIndex, 2)
    }
    
    func testTokenizeIntValid() {
        let string = "921"
        let scanner = NSScanner(string: string)
        let tokenizer = IntTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testTokenizeIntInvalidString() {
        let string = "dfge"
        let scanner = NSScanner(string: string)
        let tokenizer = IntTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testTokenizeIntRange() {
        let string = "921"
        let scanner = NSScanner(string: string)
        let tokenizer = IntTokenizer(scanner: scanner)
        let token = try! tokenizer.makeToken()
        XCTAssertEqual(token.startIndex, 0)
        XCTAssertEqual(token.stopIndex, 2)
    }
    
    func testTokenizeFloatValid() {
        let string = "0.25"
        let scanner = NSScanner(string: string)
        let tokenizer = FloatTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testTokenizeFloatInvalid() {
        let string = "jn.25"
        let scanner = NSScanner(string: string)
        let tokenizer = FloatTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testTokenizeFloatRange() {
        let string = "0.252"
        let scanner = NSScanner(string: string)
        let tokenizer = FloatTokenizer(scanner: scanner)
        let token = try! tokenizer.makeToken()
        XCTAssertEqual(token.startIndex, 0)
        XCTAssertEqual(token.stopIndex, 4)
    }
    
    func testTokenizeDynamicMarkingValid() {
        let string = "ofppp"
        let scanner = NSScanner(string: string)
        let tokenizer = DynamicMarkingTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
        XCTAssertEqual(token!.startIndex, 0)
        XCTAssertEqual(token!.stopIndex, 4)
    }
    
    func testTokenizeDynamicMarkingInvalid() {
        let string = "jhfek0.82"
        let scanner = NSScanner(string: string)
        let tokenizer = DynamicMarkingTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testTokenizeArticulationValid() {
        ["-", ".", ">"].forEach {
            let scanner = NSScanner(string: $0)
            let tokenizer = ArticulationMarkingTokenizer(scanner: scanner)
            let token = try? tokenizer.makeToken()
            XCTAssertNotNil(token)
        }
    }
    
    func testTokenizeArticulationInvalid() {
        let string = "x_3r"
        let scanner = NSScanner(string: string)
        let tokenizer = ArticulationMarkingTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testTokenizePitchFloatValid() {
        let string = "60.25"
        let scanner = NSScanner(string: string)
        let tokenizer = PitchTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testTokenizePitchFloatInvalid() {
        let string = "lke"
        let scanner = NSScanner(string: string)
        let tokenizer = PitchTokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNil(token)
    }
    
    func testTokenizePithFloatRange() {
        let string = "60.25"
        let scanner = NSScanner(string: string)
        let tokenizer = PitchTokenizer(scanner: scanner)
        let token = try! tokenizer.makeToken()
        XCTAssertEqual(token.startIndex, 0)
        XCTAssertEqual(token.stopIndex, 4)
    }
    
    func testTokenizePitchStringValid() {
        ["c5", "eb8", "eq#_down", "g_qb_up_5"].forEach {
            let scanner = NSScanner(string: $0)
            let tokenizer = PitchTokenizer(scanner: scanner)
            let token = try? tokenizer.makeToken()
            XCTAssertNotNil(token)
        }
    }
    
    func testTokenizePitchStringRange() {
        let string = "g_qb_up_5"
        let scanner = NSScanner(string: string)
        let tokenizer = PitchTokenizer(scanner: scanner)
        let token = try! tokenizer.makeToken()
        XCTAssertEqual(token.startIndex, 0)
        XCTAssertEqual(token.stopIndex, 8)
    }
    
    func testTokenizeLineManyValues() {
        let string = "\t1-p 60 -a . > -d fff"
        let scanner = NSScanner(string: string)
        let tokenizer = Tokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        if let tokenContainer = token as? TokenContainer {
            XCTAssertEqual(tokenContainer.tokens.count, 1)
        }
    }
    
    func testSlurStart() {
        let string = "("
        let scanner = NSScanner(string: string)
        let tokenizer = Tokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testSlurStop() {
        let string = ")"
        let scanner = NSScanner(string: string)
        let tokenizer = Tokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testExtensionStop() {
        let string = "<-"
        let scanner = NSScanner(string: string)
        let tokenizer = Tokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testNode() {
        let scanner = NSScanner(string: "•")
        let tokenizer = Tokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testEdge() {
        let scanner = NSScanner(string: "~")
        let tokenizer = Tokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testNodeAndEdgeLines() {
        let string = "# 3,8\n\t1 •\n\t1 ~\n\t1 •"
        let scanner = NSScanner(string: string)
        let tokenizer = Tokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testLabel() {
        let string = "1 -p 60 -l 'pizz'"
        let scanner = NSScanner(string: string)
        let tokenizer = Tokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testScore() {
        let string = "P: VN vn Violin\n\n#\n| 1,8 VN vn\n\t1 •\n\t1 -p 60\n\t1 -p 60 -a >"
        let scanner = NSScanner(string: string)
        let tokenizer = Tokenizer(scanner: scanner)
        let token = try? tokenizer.makeToken()
        XCTAssertNotNil(token)
    }
    
    func testLineComment() {
        let string = "\t1 -p 60 -d fff // -a ."
        let scanner = NSScanner(string: string)
        let tokenizer = Tokenizer(scanner: scanner)
        let tokenContainer = try! tokenizer.makeToken() as! TokenContainer
        if let lineContainer = tokenContainer.tokens.first as? TokenContainer {
            if let leafContainer = lineContainer.tokens.first as? TokenContainer {
                XCTAssertEqual(leafContainer.tokens.count, 3)
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
}