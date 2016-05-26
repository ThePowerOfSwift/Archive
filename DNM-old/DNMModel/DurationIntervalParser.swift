//
//  DurationIntervalParser.swift
//  DNMModel
//
//  Created by James Bean on 1/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class DurationIntervalParser: Parser {
    
    private enum RelationMode {
        case Until, At
    }
    
    public override func resultWith(scanner: NSScanner) -> Any? {
        
        guard let left = durationScannedBy(scanner) else {
            didFail = true
            return nil
        }
        guard let mode = durationModeFrom(scanner) else {
            didFail = true
            return nil
        }
        guard let right = durationScannedBy(scanner) else {
            didFail = true
            return nil
        }
        
        return makeDurationIntervalWithMode(mode, leftDuration: left, andRightDuration: right)
    }
    
    private func makeDurationIntervalWithMode(durationMode: RelationMode,
        leftDuration: Duration, andRightDuration rightDuration: Duration
    ) -> DurationInterval
    {
        switch durationMode {
        case .Until:
            return DurationInterval(startDuration: leftDuration, stopDuration: rightDuration)
        case .At:
            return DurationInterval(duration: leftDuration, startDuration: rightDuration)
        }
    }
    
    private func durationScannedBy(scanner: NSScanner) -> Duration? {
        return DurationParser().parseWith(scanner) as? Duration
    }
    
    private func durationModeFrom(scanner: NSScanner) -> RelationMode? {
        if untilOperatorIsScannedBy(scanner) { return .Until }
        else if atOperatorIsScannedBy(scanner) { return .At }
        return nil
    }
    
    private func untilOperatorIsScannedBy(scanner: NSScanner) -> Bool {
        var str: NSString?
        return scanner.scanString("->", intoString: &str)
    }
    
    private func atOperatorIsScannedBy(scanner: NSScanner) -> Bool {
        var str: NSString?
        return scanner.scanString("@", intoString: &str)
    }
}