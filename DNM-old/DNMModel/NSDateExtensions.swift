//
//  NSDateExtensions.swift
//  DNMModel
//
//  Created by James Bean on 1/9/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }