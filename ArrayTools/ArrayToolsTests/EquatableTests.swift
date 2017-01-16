//
//  EquatableTests.swift
//  ArrayTools
//
//  Created by James Bean on 4/27/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import ArrayTools

class EquatableTests: XCTestCase {

    func testIsHomogeneousEmptyNil() {
        let array: [Int] = []
        XCTAssertNil(array.isHomogeneous)
    }
    
    func testIsHomogeneousSingleElementNil() {
        let array: [Int] = [0]
        XCTAssertNil(array.isHomogeneous)
    }
    
    func testIsHeterogeneousEmptyNil() {
        let array: [Int] = []
        XCTAssertNil(array.isHeterogeneous)
    }
    
    func testIsHeterogeneousSingleElementNil() {
        let array: [Int] = [0]
        XCTAssertNil(array.isHeterogeneous)
    }
    
    func testIsHomoegeneous() {
        XCTAssert([1,1,1,1,1].isHomogeneous!)
    }
    
    func testIsHomogeneousFail() {
        XCTAssertFalse([1,2,1,1].isHomogeneous!)
    }
    
    func testIsHeterogeneousFalse() {
        XCTAssertFalse([1,1,1,1,1].isHeterogeneous!)
    }
    
    func testAmountOfElementNotPresentZero() {
        let array = [1,2,3,4]
        XCTAssertEqual(array.amount(of: 0), 0)
    }
    
    func testAmountOfElementPresent() {
        let array = [1,2,3,4,1]
        XCTAssertEqual(array.amount(of: 1), 2)
    }
    
    func testExtractAllNotPresent() {
        
        let array = [1,2,3,4]
        let (expectedExtracted, expectedRemaining): ([Int],[Int]) = ([], [1,2,3,4])
        let (resultExtracted, resultRemaining) = array.extractAll(0)
        
        XCTAssertEqual(expectedExtracted, resultExtracted)
        XCTAssertEqual(expectedRemaining, resultRemaining)
    }
    
    func testExtractAllPresent() {
        
        let array = [1,2,3,4,1]
        let (expectedExtracted, expectedRemaining): ([Int],[Int]) = ([1,1], [2,3,4])
        let (resultExtracted, resultRemaining) = array.extractAll(1)
        
        XCTAssertEqual(expectedExtracted, resultExtracted)
        XCTAssertEqual(expectedRemaining, resultRemaining)
    }
    
    func testSortedWithOrderOfContentsSourceEmpty() {
        
        let source: [Int] = []
        let reference = [1,2,3]
        
        XCTAssertEqual(source.sorted(withOrderOfContentsIn: reference), [])
    }
    
    func testSortedWithOrderOfContentsReferenceEmpty() {
        
        let source = [1,2,3]
        let reference: [Int] = []
        
        XCTAssertEqual(source.sorted(withOrderOfContentsIn: reference), [1,2,3])
    }
    
    func testSortedWithOrderedOfContentsAllPresent() {
        
        let source = [1,2,3]
        let reference: [Int] = [2,3,1]
        
        XCTAssertEqual(source.sorted(withOrderOfContentsIn: reference), [2,3,1])
    }
    
    func testExtractDuplicatesNone() {
     
        let array = [1,2,3]
        let (duplicates, remaining) = array.extractDuplicates()
        
        XCTAssertEqual(duplicates, [])
        XCTAssertEqual(remaining, array)
    }

    func testExtractDuplicatesSome() {
        
        let array = [1,2,2,3,1]
        let (duplicates, remaining) = array.extractDuplicates()
        
        XCTAssertEqual(duplicates, [2,1])
        XCTAssertEqual(remaining, [1,2,3])
    }
    
    func testUnique() {
        let array = [1,2,2,3,1]
        XCTAssertEqual(array.unique, [1,2,3])
    }
    
    func testReplaceElementNotYetExtant() {
        
        var array: [Int] = [1,2,3,4]
        
        do {
            try array.replace(0, with: 5)
        } catch ArrayError.removalError {
            // success
        } catch _ {
            XCTFail()
        }
    }
    
    func testReplaceElementExtant() {
        
        var array: [Int] = [1,2,5,4]
        
        do {
            try array.replace(5, with: 3)
            XCTAssertEqual(array, [1,2,3,4])
        } catch {
            XCTFail()
        }
    }
    
    func testEqualityTrue() {
        let a: [Int] = [1,2,3]
        let b: [Int] = [1,2,3]
        XCTAssert(a == b)
    }
    
    func testEqualityFalse() {
        let a: [Int] = [1,2,3]
        let b: [Int] = [1,2,2]
        XCTAssertFalse(a == b)
    }
}
