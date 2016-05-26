//
//  DurationParser.swift
//  DNMModel
//
//  Created by James Bean on 1/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

/// Parses string input into a `Duration`, using the syntax: "1,8" (beats,subdivisionLevel)
public class DurationParser: Parser {
    
    public override func resultWith(scanner: NSScanner) -> Any? {
        
        guard let beatsValue = intValueScannedBy(scanner) else {
            didFail = true
            return nil
        }
        
        guard seperatorIsScannedBy(scanner) else {
            didFail = true
            return nil
        }
        
        guard let subdivisionValue = intValueScannedBy(scanner) else {
            didFail = true
            return nil
        }
        return Duration(beatsValue, subdivisionValue)
    }
    
    private func seperatorIsScannedBy(scanner: NSScanner) -> Bool {
        var str: NSString?
        return scanner.scanString(",", intoString: &str)
    }
    
    private func intValueScannedBy(scanner: NSScanner) -> Int? {
        var intValue: Int32 = 0
        if scanner.scanInt(&intValue) { return Int(intValue) }
        return nil
    }
}