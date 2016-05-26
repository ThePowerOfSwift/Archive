//
//  DurationNodeParser.swift
//  DNMModel
//
//  Created by James Bean on 1/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class DurationNodeParser {
    
    public static func parse(string: String) -> DurationNode? {
        if string == "" { return nil }
        let scanner = NSScanner(string: string)
        return parseWith(scanner)
    }
    
    public static func parseWith(scanner: NSScanner) -> DurationNode? {
        if let durationInterval = durationIntervalScannedBy(scanner) {
            return DurationNode.with(durationInterval)
            //return DurationNode(durationInterval: durationInterval)
        } else if let duration = durationScannedBy(scanner) {
            return DurationNode.with(duration)
        }
        // manage components
        return nil
    }
    
    private static func durationIntervalScannedBy(scanner: NSScanner) -> DurationInterval? {
        return DurationIntervalParser().parseWith(scanner) as? DurationInterval
    }
    
    private static func durationScannedBy(scanner: NSScanner) -> Duration? {
        return DurationParser().parseWith(scanner) as? Duration
    }
}