//
//  StringExtensions.swift
//  DNMModel
//
//  Created by James Bean on 11/17/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import Foundation

public extension String {
    
    subscript (i: Int) -> Character? {
        if i >= self.characters.count { return nil }
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String? {
        let charOrNil: Character? = self[i]
        guard let char = charOrNil else { return nil }
        return String(char as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(
            Range(
                start: startIndex.advancedBy(r.startIndex),
                end: startIndex.advancedBy(r.endIndex)
            )
        )
    }
    
    func indent(amount amount: Int) -> String {
        var result: String = self
        result = result.insertTabs(amount: amount, atIndex: 0)
        var c = 0
        while c < result.characters.count {
            if result[c] == Character("\n") {
                result = result.insertTabs(amount: amount, atIndex: c + 1)
                c += amount
            }
            c += 1
        }
        return result
    }
    
    func insertTabs(amount amount: Int, atIndex index: Int) -> String {
        var result: String = self
        for _ in 0..<amount { result = result.insert("\t", atIndex: index) }
        return result
    }
    
    // This doesn't scale well
    func insert(insert: String, atIndex index: Int) -> String {
        let prefix = String(self.characters.prefix(index))
        let suffix = String(self.characters.suffix(self.characters.count - index))
        return prefix + insert + suffix
    }
}