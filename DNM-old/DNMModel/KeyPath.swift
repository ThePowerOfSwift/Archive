//
//  KeyPath.swift
//  DNMModel
//
//  Created by James Bean on 1/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class KeyPath {
    
    public var keys: [String] = []
    
    public var count: Int { return keys.count }
    
    public init(_ keys: String ...) {
        self.keys = keys
    }
    
    public init(_ keys: [String]) {
        self.keys = keys
    }
}

extension KeyPath: CustomStringConvertible {
    
    public var description: String {
        var result = "Path: "
        for (k, key) in keys.enumerate() {
            if k > 0 { result += " -> " }
            result += key
        }
        return result
    }
}