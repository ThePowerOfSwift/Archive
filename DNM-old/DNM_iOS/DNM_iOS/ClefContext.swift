//
//  ClefContext.swift
//  DNM
//
//  Created by James Bean on 1/14/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

// TODO: Implement DurationSpanning ClefContext extension?
public struct ClefContext {
    
    public var type: ClefStaffType
    public var transposition: Int
    public var showsTransposition: Bool
    
    public init(type: ClefStaffType, transposition: Int, showsTransposition: Bool) {
        self.type = type
        self.transposition = transposition
        self.showsTransposition = showsTransposition
    }
}