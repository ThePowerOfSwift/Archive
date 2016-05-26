//
//  Parser.swift
//  DNMModel
//
//  Created by James Bean on 1/19/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class Parser {
    
    internal var startLocation: Int = 0
    internal var didFail = false
    
    public func parse(string: String) -> Any? {
        if string == "" { return nil }
        let scanner = makeScannerWith(string)
        return parseWith(scanner)
    }
    
    internal func makeScannerWith(string: String) -> NSScanner {
        let scanner = NSScanner(string: string)
        return scanner
    }
    
    public func parseWith(scanner: NSScanner) -> Any? {
        setStartLocationWith(scanner)
        defer { unwindScannerIfNecessary(scanner) }
        return resultWith(scanner)
    }
    
    internal func resultWith(scanner: NSScanner) -> Any? {
        return nil // override
    }
    
    internal func setStartLocationWith(scanner: NSScanner) {
        startLocation = scanner.scanLocation
    }
    
    internal func unwindScannerIfNecessary(scanner: NSScanner) {
        if didFail { scanner.scanLocation = startLocation }
    }
}